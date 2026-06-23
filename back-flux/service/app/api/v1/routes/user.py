from fastapi import APIRouter, Depends, Request
from sqlalchemy import func
from sqlalchemy.orm import Session, aliased

from app.api.v1.schemas.user import UserProfileResponse
from app.core.config import settings
from app.core.errors import raise_backend_error
from app.core.session import get_current_session
from app.core.user_event_logs import user_event_logs
from app.db import get_db
from app.db.models import (
    User,
    Note,
    Reminder,
    NoteLink,
    RegistrationSession,
)

router = APIRouter(prefix="/user", tags=["User"])


def _build_image_link(image: str | None, image_provider: str | None) -> str | None:
    if not image:
        return None

    if image_provider == "local":
        image_endpoint = (settings.image_base_endpoint or "").rstrip("/")
        image_path = image.lstrip("/")
        return f"{image_endpoint}/{image_path}"

    return image


@router.get("/me", response_model=UserProfileResponse)
async def get_current_user_profile(
    request: Request,
    session: RegistrationSession = Depends(get_current_session),
    db: Session = Depends(get_db),
):
    language = session.language or "en"

    user = (
        db.query(User)
        .filter(User.user_id == session.user_id)
        .first()
    )

    if user is None:
        raise_backend_error(
            db=db,
            request=request,
            code="USER_NOT_FOUND",
            language=language,
            user_id=session.user_id,
            session_id=session.id,
            device_id=session.device_id,
            platform=session.platform,
        )

    notes_count = (
        db.query(func.count(Note.note_id))
        .filter(
            Note.user_id == user.user_id,
            Note.deleted.is_(False),
        )
        .scalar()
        or 0
    )

    reminders_count = (
        db.query(func.count(Reminder.reminder_id))
        .filter(
            Reminder.user_id == user.user_id,
            Reminder.deleted.is_(False),
        )
        .scalar()
        or 0
    )

    FromNote = aliased(Note)
    ToNote = aliased(Note)

    note_links_count = (
        db.query(func.count(NoteLink.link_id))
        .join(FromNote, NoteLink.from_note_id == FromNote.note_id)
        .join(ToNote, NoteLink.to_note_id == ToNote.note_id)
        .filter(
            FromNote.user_id == user.user_id,
            ToNote.user_id == user.user_id,
            FromNote.deleted.is_(False),
            ToNote.deleted.is_(False),
        )
        .scalar()
        or 0
    )

    sessions_count = (
        db.query(func.count(RegistrationSession.id))
        .filter(
            RegistrationSession.user_id == user.user_id,
        )
        .scalar()
        or 0
    )

    user_event_logs(
        db=db,
        request=request,
        status_code=200,
        event="USER_PROFILE_GET",
        user_id=user.user_id,
        session_id=session.id,
        device_id=session.device_id,
        platform=session.platform,
    )

    return UserProfileResponse(
        name=user.name,
        phone=user.phone,
        email=user.email,
        image=_build_image_link(
            image=user.img,
            image_provider=user.img_provider,
        ),
        notes_count=notes_count,
        reminders_count=reminders_count,
        note_links_count=note_links_count,
        sessions_count=sessions_count,
        session_provider=session.provider,
        is_verified=session.is_verified,
    )