from datetime import datetime, timedelta, timezone
import uuid
import secrets

from fastapi import APIRouter, Depends, Request
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session, load_only
from sqlalchemy import insert
from jwt.exceptions import ExpiredSignatureError

from app.api.v1.schemas.auth import YandexLoginResponse, YandexLoginRequest, YandexCallbackRequest, \
    YandexCallbackResponse
from app.db import get_db
from app.db.models import User, RegistrationSession, YandexLoginSession
from app.core.config import settings
from app.core.user_event_logs import user_event_logs
from app.core.jwt import create_state, decode_state
from app.utilits.yandex_oauth import get_token, get_profile
from app.core.errors import raise_backend_error

router = APIRouter(prefix="/auth", tags=["Auth"])


@router.post("/yandex/login", response_model=YandexLoginResponse)
async def login(
        request: Request,
        request_data: YandexLoginRequest,
        db: Session = Depends(get_db),
):
    now = datetime.now(timezone.utc)

    session = (
        db.query(YandexLoginSession)
        .filter(
            YandexLoginSession.device_id == request_data.device_id,
            YandexLoginSession.platform == request_data.platform,
            YandexLoginSession.language == request_data.language,
            YandexLoginSession.used_at.is_(None),
            YandexLoginSession.expires_at > now,
        )
        .first()
    )

    if request_data.platform == "web":
        redirect_uri = settings.yandex_redirect_web
    else:
        redirect_uri = settings.yandex_redirect_mobile

    if session:
        state = create_state(
            device_id=session.device_id,
            platform=session.platform,
            session_id=str(session.id),
        )

        url = (
            "https://oauth.yandex.ru/authorize"
            "?response_type=code"
            f"&client_id={settings.yandex_client_id}"
            f"&redirect_uri={redirect_uri}"
            f"&state={state}"
        )

        user_event_logs(
            db=db,
            request=request,
            event="YANDEX_LOGIN_REUSED",
            device_id=request_data.device_id,
            platform=request_data.platform,
        )

        return YandexLoginResponse(url=url)

    session_id = uuid.uuid4()

    session = YandexLoginSession(
        id=session_id,
        device_id=request_data.device_id,
        platform=request_data.platform,
        language=request_data.language,
        expires_at=now + timedelta(minutes=20),
        used_at=None,
    )

    db.add(session)
    db.commit()

    state = create_state(
        device_id=request_data.device_id,
        platform=request_data.platform,
        session_id=str(session_id),
    )

    url = (
        "https://oauth.yandex.ru/authorize"
        "?response_type=code"
        f"&client_id={settings.yandex_client_id}"
        f"&redirect_uri={redirect_uri}"
        f"&state={state}"
    )

    user_event_logs(
        db=db,
        request=request,
        status_code=200,
        event="YANDEX_LOGIN_START",
        device_id=request_data.device_id,
        platform=request_data.platform,
    )

    return YandexLoginResponse(url=url)


@router.post("/yandex/callback", response_model=YandexCallbackResponse)
async def callback(
        request: Request,
        request_data: YandexCallbackRequest,
        db: Session = Depends(get_db),
):
    try:
        data = decode_state(request_data.state)
    except ExpiredSignatureError:
        raise_backend_error(
            db=db,
            request=request,
            code="STATE_EXPIRED",
            language="en",
        )

    session_id = data.get("session_id")
    device_id = data.get("device_id")
    platform = data.get("platform")

    if not session_id or not device_id or not platform:
        raise_backend_error(
            db=db,
            request=request,
            code="SESSION_NOT_FOUND",
            language="en",
        )

    now = datetime.now(timezone.utc)

    yandex_session = (
        db.query(YandexLoginSession)
        .filter(
            YandexLoginSession.id == session_id,
            YandexLoginSession.used_at.is_(None),
            YandexLoginSession.expires_at > now,
        )
        .first()
    )

    if not yandex_session:
        raise_backend_error(
            db=db,
            request=request,
            code="SESSION_NOT_FOUND",
            language="en",
        )

    if (
            yandex_session.device_id != device_id
            or yandex_session.platform != platform
    ):
        raise_backend_error(
            db=db,
            request=request,
            code="SESSION_NOT_FOUND",
            language="en",
        )

    access_token = get_token(request_data.code)
    profile = get_profile(access_token)

    email = profile.get("default_email")
    if not email:
        raise_backend_error(
            db=db,
            request=request,
            code="YANDEX_NO_EMAIL",
            language=yandex_session.language or "en",
        )

    phone = profile.get("default_phone", {}).get("number")
    name = profile.get("display_name") or profile.get("real_name")
    avatar_id = profile.get("default_avatar_id")

    avatar = None
    if avatar_id:
        avatar = f"https://avatars.yandex.net/get-yapic/{avatar_id}/islands-200"

    user = db.query(User).filter(User.email == email).first()

    if not user:
        user = User(
            email=email,
            phone=phone,
            name=name,
            img=avatar,
            img_provider="ya",
        )
        db.add(user)
        db.flush()
    else:
        user.phone = phone or user.phone
        user.img = avatar or user.img
        user.name = name or user.name

    session_token = secrets.token_urlsafe(32)

    registration_session = RegistrationSession(
        user_id=user.user_id,
        device_id=yandex_session.device_id,
        platform=yandex_session.platform,
        provider="ya",
        session_token=session_token,
        is_verified=True,
        expires_at=now + timedelta(days=180),
    )

    yandex_session.used_at = now

    db.add(registration_session)
    db.commit()

    user_event_logs(
        db=db,
        request=request,
        status_code=200,
        event="YANDEX_SUCCESS_LOGIN",
        device_id=yandex_session.device_id,
        platform=yandex_session.platform,
    )

    return YandexCallbackResponse(token=session_token)