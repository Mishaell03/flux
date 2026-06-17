from fastapi import HTTPException, Request
from sqlalchemy.orm import Session
from starlette.requests import HTTPConnection

from app.db.models import BackendError, BackendErrorLocalization
from app.core.user_event_logs import user_event_logs


def build_backend_error(
    db: Session,
    request: HTTPConnection,
    *,
    code: str,
    language: str = "en",
    user_id: int | None = None,
    session_id: str | None = None,
    device_id: str | None = None,
    platform: str | None = None,
) -> tuple[int, dict]:
    backend_error = (
        db.query(BackendError)
        .filter(BackendError.code == code)
        .first()
    )

    if backend_error is None:
        user_event_logs(
            db,
            request=request,
            event="UNKNOWN_ERROR",
            status_code=500,
            device_id=device_id,
            user_id=user_id,
            session_id=session_id,
            platform=platform,
        )

        return 500, {
            "code": "UNKNOWN_ERROR",
            "message": "Unknown backend error",
        }

    localization = (
        db.query(BackendErrorLocalization)
        .filter(
            BackendErrorLocalization.code == code,
            BackendErrorLocalization.language == language,
        )
        .first()
    )

    if localization is None:
        localization = (
            db.query(BackendErrorLocalization)
            .filter(
                BackendErrorLocalization.code == code,
                BackendErrorLocalization.language == "en",
            )
            .first()
        )

    user_event_logs(
        db,
        request=request,
        event=backend_error.code,
        status_code=backend_error.http_status,
        device_id=device_id,
        user_id=user_id,
        session_id=session_id,
        platform=platform,
    )

    return backend_error.http_status, {
        "code": backend_error.code,
        "message": localization.message if localization else backend_error.code,
    }


def raise_backend_error(
    db: Session,
    request: Request,
    *,
    code: str,
    language: str = "en",
    user_id: int | None = None,
    session_id: str | None = None,
    device_id: str | None = None,
    platform: str | None = None,
) -> None:
    status_code, detail = build_backend_error(
        db=db,
        request=request,
        code=code,
        language=language,
        user_id=user_id,
        session_id=session_id,
        device_id=device_id,
        platform=platform,
    )

    raise HTTPException(
        status_code=status_code,
        detail=detail,
    )