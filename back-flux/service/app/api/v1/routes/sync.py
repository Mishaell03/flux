from datetime import datetime, timezone
from uuid import UUID

from fastapi import APIRouter, Depends, Request
from sqlalchemy.orm import Session

from app.api.v1.schemas.sync import (
    SyncStatusRequest,
    SyncStatusResponse,
    SyncStatusItem,
    SyncPushRequest,
    SyncPushResponse,
    SyncPushResultItem,
)

from app.core.session import get_current_session
from app.core.user_event_logs import user_event_logs
from app.db import get_db
from app.db.models import RegistrationSession, Note, Reminder


router = APIRouter(prefix="/sync", tags=["Sync"])


def normalize_datetime(value: datetime) -> datetime:
    if value.tzinfo is None:
        return value.replace(tzinfo=timezone.utc)

    return value.astimezone(timezone.utc)

def is_client_newer(client_updated_at: datetime, server_updated_at: datetime) -> bool:
    return normalize_datetime(client_updated_at) > normalize_datetime(server_updated_at)

def build_sync_status(
        client_versions: dict[UUID, datetime],
        server_versions: dict[UUID, datetime],
) -> list[SyncStatusItem]:
    result: list[SyncStatusItem] = []

    all_ids = set(client_versions.keys()) | set(server_versions.keys())

    for entity_id in all_ids:
        client_updated_at = client_versions.get(entity_id)
        server_updated_at = server_versions.get(entity_id)

        # есть на клиенте, нет на сервере => клиент отправит объект
        if server_updated_at is None:
            result.append(
                SyncStatusItem(
                    id=entity_id,
                    is_update_required=True,
                    server_has_latest_version=False,
                )
            )
            continue

        # есть на сервере, нет на клиенте => клиент скачает объект
        if client_updated_at is None:
            result.append(
                SyncStatusItem(
                    id=entity_id,
                    is_update_required=True,
                    server_has_latest_version=True,
                )
            )
            continue

        client_updated_at = normalize_datetime(client_updated_at)
        server_updated_at = normalize_datetime(server_updated_at)

        if server_updated_at == client_updated_at:
            result.append(
                SyncStatusItem(
                    id=entity_id,
                    is_update_required=False,
                    server_has_latest_version=True,
                )
            )
            continue

        if server_updated_at > client_updated_at:
            result.append(
                SyncStatusItem(
                    id=entity_id,
                    is_update_required=True,
                    server_has_latest_version=True,
                )
            )
            continue

        # client_updated_at > server_updated_at
        result.append(
            SyncStatusItem(
                id=entity_id,
                is_update_required=True,
                server_has_latest_version=False,
            )
        )

    return result


@router.post("/status", response_model=SyncStatusResponse)
async def get_sync_status(
        request: Request,
        request_data: SyncStatusRequest,
        session: RegistrationSession = Depends(get_current_session),
        db: Session = Depends(get_db),
):
    client_notes = {
        item.id: item.updated_at
        for item in request_data.notes
    }

    client_reminders = {
        item.id: item.updated_at
        for item in request_data.reminders
    }

    server_notes_rows = (
        db.query(Note.note_id, Note.updated_at)
        .filter(Note.user_id == session.user_id)
        .all()
    )

    server_reminders_rows = (
        db.query(Reminder.reminder_id, Reminder.updated_at)
        .filter(Reminder.user_id == session.user_id)
        .all()
    )

    server_notes = {
        row.note_id: row.updated_at
        for row in server_notes_rows
    }

    server_reminders = {
        row.reminder_id: row.updated_at
        for row in server_reminders_rows
    }

    notes_status = build_sync_status(
        client_versions=client_notes,
        server_versions=server_notes,
    )

    reminders_status = build_sync_status(
        client_versions=client_reminders,
        server_versions=server_reminders,
    )

    user_event_logs(
        db=db,
        request=request,
        status_code=200,
        event="SYNC_STATUS",
        user_id=session.user_id,
        session_id=session.id,
        device_id=session.device_id,
        platform=session.platform,
    )

    return SyncStatusResponse(
        notes=notes_status,
        reminders=reminders_status,
    )


@router.post("/push", response_model=SyncPushResponse)
async def push_sync_data(
        request: Request,
        request_data: SyncPushRequest,
        session: RegistrationSession = Depends(get_current_session),
        db: Session = Depends(get_db),
):
    notes_result: list[SyncPushResultItem] = []
    reminders_result: list[SyncPushResultItem] = []

    now = datetime.now(timezone.utc)

    # 1. Сначала синхронизируем заметки,
    # потому что reminders.note_id ссылается на notes.note_id.
    note_ids = [item.id for item in request_data.notes]

    existing_notes = {}

    if note_ids:
        notes_rows = (
            db.query(Note)
            .filter(Note.note_id.in_(note_ids))
            .all()
        )

        existing_notes = {
            note.note_id: note
            for note in notes_rows
        }

    for item in request_data.notes:
        note = existing_notes.get(item.id)

        # UUID принадлежит другому пользователю
        if note and note.user_id != session.user_id:
            notes_result.append(
                SyncPushResultItem(
                    id=item.id,
                    action="rejected",
                    server_updated_at=None,
                    message="NOTE_BELONGS_TO_ANOTHER_USER",
                )
            )
            continue

        # Заметки нет на сервере => создаём
        if not note:
            note = Note(
                note_id=item.id,
                user_id=session.user_id,
                title=item.title,
                content=item.content,
                deleted=item.deleted,
                deleted_at=item.deleted_at,
                created_at=item.created_at or now,
                updated_at=item.updated_at,
            )

            db.add(note)

            notes_result.append(
                SyncPushResultItem(
                    id=item.id,
                    action="created",
                    server_updated_at=item.updated_at,
                )
            )

            continue

        # Серверная версия такая же или новее => ничего не меняем
        if not is_client_newer(
                client_updated_at=item.updated_at,
                server_updated_at=note.updated_at,
        ):
            notes_result.append(
                SyncPushResultItem(
                    id=item.id,
                    action="skipped",
                    server_updated_at=note.updated_at,
                    message="SERVER_VERSION_IS_NEWER_OR_EQUAL",
                )
            )
            continue

        # Клиентская версия новее => обновляем сервер
        note.title = item.title
        note.content = item.content
        note.deleted = item.deleted
        note.deleted_at = item.deleted_at
        note.updated_at = item.updated_at

        notes_result.append(
            SyncPushResultItem(
                id=item.id,
                action="updated",
                server_updated_at=item.updated_at,
            )
        )

    db.flush()

    # 2. После заметок синхронизируем напоминания.
    reminder_ids = [item.id for item in request_data.reminders]

    existing_reminders = {}

    if reminder_ids:
        reminders_rows = (
            db.query(Reminder)
            .filter(Reminder.reminder_id.in_(reminder_ids))
            .all()
        )

        existing_reminders = {
            reminder.reminder_id: reminder
            for reminder in reminders_rows
        }

    linked_note_ids = {
        item.note_id
        for item in request_data.reminders
        if item.note_id is not None
    }

    existing_user_note_ids = set()

    if linked_note_ids:
        note_id_rows = (
            db.query(Note.note_id)
            .filter(
                Note.user_id == session.user_id,
                Note.note_id.in_(linked_note_ids),
            )
            .all()
        )

        existing_user_note_ids = {
            row[0]
            for row in note_id_rows
        }

    for item in request_data.reminders:
        reminder = existing_reminders.get(item.id)

        # Нельзя привязать напоминание к чужой или несуществующей заметке
        if item.note_id is not None and item.note_id not in existing_user_note_ids:
            reminders_result.append(
                SyncPushResultItem(
                    id=item.id,
                    action="rejected",
                    server_updated_at=None,
                    message="NOTE_NOT_FOUND",
                )
            )
            continue

        # UUID принадлежит другому пользователю.
        if reminder and reminder.user_id != session.user_id:
            reminders_result.append(
                SyncPushResultItem(
                    id=item.id,
                    action="rejected",
                    server_updated_at=None,
                    message="REMINDER_BELONGS_TO_ANOTHER_USER",
                )
            )
            continue

        # Напоминания нет на сервере => создаём
        if not reminder:
            reminder = Reminder(
                reminder_id=item.id,
                user_id=session.user_id,
                note_id=item.note_id,
                remind_at=item.remind_at,
                repeat_rule=item.repeat_rule,
                is_done=item.is_done,
                deleted=item.deleted,
                created_at=item.created_at or now,
                updated_at=item.updated_at,
            )

            db.add(reminder)

            reminders_result.append(
                SyncPushResultItem(
                    id=item.id,
                    action="created",
                    server_updated_at=item.updated_at,
                )
            )

            continue

        # Серверная версия такая же или новее => ничего не меняем
        if not is_client_newer(
                client_updated_at=item.updated_at,
                server_updated_at=reminder.updated_at,
        ):
            reminders_result.append(
                SyncPushResultItem(
                    id=item.id,
                    action="skipped",
                    server_updated_at=reminder.updated_at,
                    message="SERVER_VERSION_IS_NEWER_OR_EQUAL",
                )
            )
            continue

        # Клиентская версия новее => обновляем сервер
        reminder.note_id = item.note_id
        reminder.remind_at = item.remind_at
        reminder.repeat_rule = item.repeat_rule
        reminder.is_done = item.is_done
        reminder.deleted = item.deleted
        reminder.updated_at = item.updated_at

        reminders_result.append(
            SyncPushResultItem(
                id=item.id,
                action="updated",
                server_updated_at=item.updated_at,
            )
        )

    db.commit()

    user_event_logs(
        db=db,
        request=request,
        status_code=200,
        event="SYNC_PUSH",
        user_id=session.user_id,
        session_id=session.id,
        device_id=session.device_id,
        platform=session.platform,
    )

    return SyncPushResponse(
        notes=notes_result,
        reminders=reminders_result,
    )