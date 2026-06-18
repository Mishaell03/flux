from datetime import datetime, timezone, timedelta

from fastapi import APIRouter, Request, Depends
from sqlalchemy.orm import Session

from app.api.v1.schemas.session import SessionResponse
from app.core.session import get_current_session
from app.core.user_event_logs import user_event_logs
from app.db import get_db
from app.db.models import RegistrationSession

router = APIRouter(prefix='/session', tags=['Session'])

@router.post('/boostrap', response_model=SessionResponse)
async def session_boostrap(
    request = Request,
    session: RegistrationSession = Depends(get_current_session),
    db: Session = Depends(get_db),
) :
    now = datetime.now(timezone.utc)

    is_session_need_update = False

    if session.expires_at <= now + timedelta(days=180):
        is_session_need_update = True

    user_event_logs(
        db=db,
        request=request,
        status_code=200,
        event="SESSION_BOOTSTRAP",
        device_id=session.device_id,
        platform=session.platform,
    )

    return SessionResponse(
        is_session_need_update=is_session_need_update
    )

@router.post('/refresh', response_model=SessionResponse)
async def refresh_session_token(
        request=Request,
        session: RegistrationSession = Depends(get_current_session),
        db: Session = Depends(get_db),
):
    now = datetime.now(timezone.utc)

    if session.expires_at >= now + timedelta(days=90):
        raise_backend_error(
            db=db,
            request=request,
            code="RECENT_SESSION",
            language=session.language,
            user_id=session.user_id,
            session_id=session.id,
            device_id=session.device_id,
            platform=session.platform
        )

    user_event_logs(
        db=db,
        request=request,
        status_code=200,
        event="SESSION_REFRESHED",
        device_id=session.device_id,
        platform=session.platform,
    )

    return SessionResponse(
        is_session_need_update=is_session_need_update
    )