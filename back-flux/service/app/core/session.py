from datetime import timezone, datetime

from fastapi import Request, Depends
from fastapi.security import HTTPAuthorizationCredentials, HTTPBearer
from sqlalchemy.orm import Session

from app.core.errors import raise_backend_error
from app.db import get_db
from app.db.models import RegistrationSession

security = HTTPBearer()

def get_current_session(
    request: Request,
    credentials: HTTPAuthorizationCredentials = Depends(security),
    db: Session = Depends(get_db),
) -> RegistrationSession:

    session_token = credentials.credentials.strip()

    if not session_token:
        raise_backend_error(
            db=db,
            request=request,
            code="INVALID_SESSION",
            language="en",
        )

    now = datetime.now(timezone.utc)

    session = (
        db.query(RegistrationSession)
        .filter(
            RegistrationSession.session_token == session_token,
            RegistrationSession.revoked_at.is_(None),
            RegistrationSession.expires_at > now,
        )
        .first()
    )

    if session is None:
        raise_backend_error(
            db=db,
            request=request,
            code="INVALID_SESSION",
            language="en",
        )

    return session