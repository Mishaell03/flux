from fastapi import APIRouter, Depends, Query, Request
from sqlalchemy import String, cast, or_
from sqlalchemy.orm import Session

from app.api.v1.schemas.search import (
    SearchNoteItemResponse,
    SearchResponse,
)
from app.core.session import get_current_session
from app.core.user_event_logs import user_event_logs
from app.db import get_db
from app.db.models import Note, Reminder, RegistrationSession


router = APIRouter(prefix="/search", tags=["Search"])


@router.get("", response_model=SearchResponse)
async def search_notes(
    request: Request,
    q: str = Query(..., min_length=1),
    limit: int = Query(default=20, ge=1, le=50),
    session: RegistrationSession = Depends(get_current_session),
    db: Session = Depends(get_db),
):
    query = q.strip()

    if not query:
        return SearchResponse(notes=[])

    pattern = f"%{query}%"

    note_rows = (
        db.query(Note)
        .filter(
            Note.user_id == session.user_id,
            Note.deleted.is_(False),
            or_(
                Note.title.ilike(pattern),
                Note.content.ilike(pattern),
            ),
        )
        .order_by(Note.updated_at.desc())
        .limit(limit)
        .all()
    )

    reminder_rows = (
        db.query(Reminder, Note)
        .join(Note, Reminder.note_id == Note.note_id)
        .filter(
            Reminder.user_id == session.user_id,
            Reminder.deleted.is_(False),
            Reminder.note_id.isnot(None),
            Note.user_id == session.user_id,
            Note.deleted.is_(False),
            or_(
                Note.title.ilike(pattern),
                Note.content.ilike(pattern),
                Reminder.repeat_rule.ilike(pattern),
                cast(Reminder.remind_at, String).ilike(pattern),
            ),
        )
        .order_by(Reminder.updated_at.desc())
        .limit(limit)
        .all()
    )

    reminder_note_ids = {
        reminder.note_id
        for reminder, _ in reminder_rows
        if reminder.note_id is not None
    }

    note_rows = (
        db.query(Note)
        .filter(
            Note.user_id == session.user_id,
            Note.deleted.is_(False),
            ~Note.note_id.in_(reminder_note_ids) if reminder_note_ids else True,
            or_(
                Note.title.ilike(pattern),
                Note.content.ilike(pattern),
            ),
        )
        .order_by(Note.updated_at.desc())
        .limit(limit)
        .all()
    )

    items: list[tuple[object, SearchNoteItemResponse]] = []

    for reminder, note in reminder_rows:
        items.append(
            (
                reminder.updated_at,
                SearchNoteItemResponse(
                    id=reminder.reminder_id,
                    type="reminder",
                    title=note.title,
                    description=note.content,
                    note_id=note.note_id,
                    remind_at=reminder.remind_at,
                    repeat_rule=reminder.repeat_rule,
                ),
            )
        )

    for note in note_rows:
        items.append(
            (
                note.updated_at,
                SearchNoteItemResponse(
                    id=note.note_id,
                    type="note",
                    title=note.title,
                    description=note.content,
                ),
            )
        )

    items.sort(key=lambda item: item[0], reverse=True)

    result_items = [
        item
        for _, item in items[:limit]
    ]

    user_event_logs(
        db=db,
        request=request,
        status_code=200,
        event="SEARCH_NOTES",
        user_id=session.user_id,
        session_id=session.id,
        device_id=session.device_id,
        platform=session.platform,
    )

    return SearchResponse(notes=result_items)