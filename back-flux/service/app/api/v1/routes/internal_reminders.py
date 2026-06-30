from datetime import datetime, timezone

from fastapi import APIRouter, Depends, Header, Request
from sqlalchemy.orm import Session

from app.api.v1.schemas.internal_reminders import (
    ReminderFireRequest,
    ReminderFireResponse,
)
from app.core.config import settings
from app.core.errors import raise_backend_error
from app.core.user_event_logs import user_event_logs
from app.db import get_db
from app.db.models import Reminder, Note, RegistrationSession
from app.core.firebase_push_service import send_push_to_tokens


router = APIRouter(prefix="/internal/reminders", tags=["Internal Reminders"])


def normalize_datetime(value: datetime) -> datetime:
    if value.tzinfo is None:
        return value.replace(tzinfo=timezone.utc)

    return value.astimezone(timezone.utc)


@router.post("/fire", response_model=ReminderFireResponse)
async def fire_reminder(
        request: Request,
        request_data: ReminderFireRequest,
        x_internal_token: str | None = Header(default=None),
        db: Session = Depends(get_db),
):
    if x_internal_token != settings.internal_api_token:
        raise_backend_error(
            db=db,
            request=request,
            code="INVALID_INTERNAL_TOKEN",
            language="en",
        )

    now = datetime.now(timezone.utc)

    reminder = (
        db.query(Reminder)
        .filter(
            Reminder.reminder_id == request_data.reminder_id,
            Reminder.user_id == request_data.user_id,
        )
        .first()
    )

    if reminder is None:
        return ReminderFireResponse(
            success=False,
            reason="REMINDER_NOT_FOUND",
        )

    if reminder.deleted or reminder.is_done:
        return ReminderFireResponse(
            success=False,
            reason="REMINDER_INACTIVE",
        )

    if normalize_datetime(reminder.updated_at) != normalize_datetime(request_data.updated_at):
        return ReminderFireResponse(
            success=False,
            reason="REMINDER_OUTDATED",
        )

    if normalize_datetime(reminder.remind_at) > now:
        return ReminderFireResponse(
            success=False,
            reason="REMINDER_NOT_DUE_YET",
        )

    note = None

    if reminder.note_id:
        note = (
            db.query(Note)
            .filter(
                Note.note_id == reminder.note_id,
                Note.user_id == reminder.user_id,
                Note.deleted.is_(False),
            )
            .first()
        )

    sessions = (
        db.query(RegistrationSession)
        .filter(
            RegistrationSession.user_id == reminder.user_id,
            RegistrationSession.revoked_at.is_(None),
            RegistrationSession.expires_at > now,
            RegistrationSession.push_token.isnot(None),
        )
        .all()
    )

    tokens = [
        row.push_token
        for row in sessions
        if row.push_token
        and not row.push_token.startswith("unsupported_fcm_")
    ]

    title = note.title if note and note.title else "Flux"
    body = note.content if note and note.content else "У вас есть напоминание"

    result = send_push_to_tokens(
        tokens=tokens,
        title=title,
        body=body,
        data={
            "type": "reminder",
            "reminder_id": str(reminder.reminder_id),
            "note_id": str(reminder.note_id) if reminder.note_id else "",
        },
    )

    reminder.is_done = True

    db.commit()

    user_event_logs(
        db=db,
        request=request,
        status_code=200,
        event="REMINDER_PUSH_SENT",
        user_id=reminder.user_id,
        device_id=None,
        platform="n8n",
    )

    return ReminderFireResponse(
        success=True,
        sent=result["sent"],
        failed=result["failed"],
    )