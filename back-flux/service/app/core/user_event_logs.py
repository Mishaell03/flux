from datetime import datetime, timezone
from sqlalchemy.orm import Session
from starlette.requests import Request

from app.db.models import UserEventLog


def user_event_logs(
    db: Session,
    *,
    request: Request,
    user_id: int | None = None,
    session_id: int | None = None,
    event: str,
    status_code: int | None = None,
    device_id: str | None = None,
    platform: str | None = None,
) -> None:
    now = datetime.now(timezone.utc)

    log = UserEventLog(
        user_id=user_id,
        session_id=session_id,
        event=event,
        request_method=request.method,
        request_path=request.url.path,
        status_code=status_code,
        device_id=device_id,
        platform=platform,
        created_at=now,
    )

    db.add(log)
    db.commit()