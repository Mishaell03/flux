import secrets
from datetime import datetime, timezone, timedelta

from fastapi import APIRouter, Request, Depends, HTTPException
from sqlalchemy.orm import Session

from app.api.v1.schemas.session import (
    SessionListItem,
    SessionListResponse,
    SessionResponse,
    SessionRefreshResponse,
)
from app.core.errors import raise_backend_error
from app.core.session import get_current_session
from app.core.user_event_logs import user_event_logs
from app.db import get_db
from app.db.models import RegistrationSession

router = APIRouter(prefix='/session', tags=['Session'])

@router.get('/active', response_model=SessionListResponse)
async def get_active_sessions(
        request: Request,
        session: RegistrationSession = Depends(get_current_session),
        db: Session = Depends(get_db),
):
    now = datetime.now(timezone.utc)

    rows = (
        db.query(RegistrationSession)
        .filter(
            RegistrationSession.user_id == session.user_id,
            RegistrationSession.revoked_at.is_(None),
            RegistrationSession.expires_at > now,
        )
        .order_by(RegistrationSession.created_at.desc())
        .all()
    )

    user_event_logs(
        db=db,
        request=request,
        status_code=200,
        event="SESSION_LIST",
        user_id=session.user_id,
        session_id=session.id,
        device_id=session.device_id,
        platform=session.platform,
    )

    return SessionListResponse(
        sessions=[
            SessionListItem(
                id=row.id,
                device_id=row.device_id,
                device_name=row.device_name,
                platform=row.platform,
                app_version=row.app_version,
                provider=row.provider,
                is_current=row.id == session.id,
                created_at=row.created_at,
                expires_at=row.expires_at,
            )
            for row in rows
        ]
    )

@router.post('/bootstrap', response_model=SessionResponse)
async def session_bootstrap(
        request: Request,
        session: RegistrationSession = Depends(get_current_session),
        db: Session = Depends(get_db),
):
    now = datetime.now(timezone.utc)

    is_session_need_update = False

    if session.expires_at <= now + timedelta(days=90):
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

@router.post('/refresh', response_model=SessionRefreshResponse)
async def refresh_session_token(
        request: Request,
        session: RegistrationSession = Depends(get_current_session),
        db: Session = Depends(get_db),
):
    now = datetime.now(timezone.utc)

    if session.expires_at > now + timedelta(days=90):
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

    session_token = secrets.token_urlsafe(32)

    session.session_token = session_token
    session.expires_at = now + timedelta(days=180)

    db.commit()

    user_event_logs(
        db=db,
        request=request,
        status_code=200,
        event="SESSION_REFRESHED",
        device_id=session.device_id,
        platform=session.platform,
    )

    return SessionRefreshResponse(
        token=session_token,
    )

@router.post('/logout')
async def logout_session(
        request: Request,
        session: RegistrationSession = Depends(get_current_session),
        db: Session = Depends(get_db),
):
    now = datetime.now(timezone.utc)

    session.expires_at = now
    session.revoked_at = now
    db.commit()

    user_event_logs(
        db=db,
        request=request,
        status_code=200,
        event="SESSION_LOGOUT",
        device_id=session.device_id,
        platform=session.platform,
    )

    return {'success': True}

@router.post('/{session_id}/revoke')
async def revoke_session(
        session_id: int,
        request: Request,
        session: RegistrationSession = Depends(get_current_session),
        db: Session = Depends(get_db),
):
    if session_id == session.id:
        raise HTTPException(status_code=400, detail="Use /session/logout for current session")

    target = (
        db.query(RegistrationSession)
        .filter(
            RegistrationSession.id == session_id,
            RegistrationSession.user_id == session.user_id,
            RegistrationSession.revoked_at.is_(None),
        )
        .first()
    )

    if target is None:
        raise HTTPException(status_code=404, detail="Session not found")

    now = datetime.now(timezone.utc)

    target.expires_at = now
    target.revoked_at = now
    db.commit()

    user_event_logs(
        db=db,
        request=request,
        status_code=200,
        event="SESSION_REVOKED",
        user_id=session.user_id,
        session_id=session.id,
        device_id=session.device_id,
        platform=session.platform,
    )

    return {'success': True}
