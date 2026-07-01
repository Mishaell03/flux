from datetime import datetime, timezone
from pathlib import Path
from typing import Literal
from uuid import UUID

from fastapi import (
    APIRouter,
    Depends,
    File,
    Form,
    HTTPException,
    Request,
    UploadFile,
)
from fastapi.responses import FileResponse
from sqlalchemy.orm import Session

from app.api.v1.schemas.note_attachments import (
    NoteAttachmentResponse,
    NoteAttachmentsListResponse,
)
from app.core.session import get_current_session
from app.core.user_event_logs import user_event_logs
from app.db import get_db
from app.db.models import Note, NoteAttachment, RegistrationSession


router = APIRouter(prefix="/note-attachments", tags=["Note attachments"])


ASSETS_DIR = Path("assets")
ATTACHMENTS_DIR = ASSETS_DIR / "note_attachments"

ALLOWED_IMAGE_MIME_TYPES = {
    "image/jpeg",
    "image/png",
    "image/webp",
    "image/heic",
    "image/heif",
}

ALLOWED_AUDIO_MIME_TYPES = {
    "audio/mpeg",
    "audio/mp3",
    "audio/mp4",
    "audio/aac",
    "audio/wav",
    "audio/x-wav",
    "audio/webm",
    "audio/ogg",
    "audio/opus",
}

EXTENSIONS_BY_MIME_TYPE = {
    "image/jpeg": "jpg",
    "image/png": "png",
    "image/webp": "webp",
    "image/heic": "heic",
    "image/heif": "heif",
    "audio/mpeg": "mp3",
    "audio/mp3": "mp3",
    "audio/mp4": "m4a",
    "audio/aac": "aac",
    "audio/wav": "wav",
    "audio/x-wav": "wav",
    "audio/webm": "webm",
    "audio/ogg": "ogg",
    "audio/opus": "opus",
}

MAX_IMAGE_SIZE_BYTES = 15 * 1024 * 1024
MAX_AUDIO_SIZE_BYTES = 50 * 1024 * 1024


@router.get("", response_model=NoteAttachmentsListResponse)
async def get_note_attachments(
    request: Request,
    session: RegistrationSession = Depends(get_current_session),
    db: Session = Depends(get_db),
):
    rows = (
        db.query(NoteAttachment)
        .filter(
            NoteAttachment.user_id == session.user_id,
        )
        .order_by(NoteAttachment.updated_at.desc())
        .all()
    )

    user_event_logs(
        db=db,
        request=request,
        status_code=200,
        event="GET_NOTE_ATTACHMENTS",
        user_id=session.user_id,
        session_id=session.id,
        device_id=session.device_id,
        platform=session.platform,
    )

    return NoteAttachmentsListResponse(
        attachments=[
            _attachment_response(row)
            for row in rows
        ]
    )


@router.post("/upload", response_model=NoteAttachmentResponse)
async def upload_note_attachment(
    request: Request,
    id: UUID = Form(...),
    note_id: UUID = Form(...),
    type: Literal["image", "audio"] = Form(...),
    created_at: datetime = Form(...),
    updated_at: datetime = Form(...),
    file: UploadFile = File(...),
    mime_type: str | None = Form(default=None),
    file_name: str | None = Form(default=None),
    duration_ms: int | None = Form(default=None),
    width: int | None = Form(default=None),
    height: int | None = Form(default=None),
    session: RegistrationSession = Depends(get_current_session),
    db: Session = Depends(get_db),
):
    note = (
        db.query(Note)
        .filter(
            Note.note_id == note_id,
            Note.user_id == session.user_id,
            Note.deleted.is_(False),
        )
        .first()
    )

    if note is None:
        raise HTTPException(status_code=404, detail="NOTE_NOT_FOUND")

    resolved_mime_type = _resolve_mime_type(
        file=file,
        mime_type=mime_type,
    )

    _validate_mime_type(
        type=type,
        mime_type=resolved_mime_type,
    )

    content = await file.read()

    _validate_file_size(
        type=type,
        size_bytes=len(content),
    )

    extension = _extension_for(
        type=type,
        mime_type=resolved_mime_type,
        file_name=file_name or file.filename,
    )

    storage_dir = ATTACHMENTS_DIR / str(session.user_id) / str(note_id)
    storage_dir.mkdir(parents=True, exist_ok=True)

    safe_file_name = f"{id}.{extension}"
    storage_path = storage_dir / safe_file_name

    now = datetime.now(timezone.utc)

    existing = (
        db.query(NoteAttachment)
        .filter(
            NoteAttachment.attachment_id == id,
        )
        .first()
    )

    if existing is not None and existing.user_id != session.user_id:
        raise HTTPException(
            status_code=403,
            detail="ATTACHMENT_BELONGS_TO_ANOTHER_USER",
        )

    storage_path.write_bytes(content)

    public_url = f"/note-attachments/{id}/file"
    remote_key = storage_path.as_posix()

    if existing is None:
        attachment = NoteAttachment(
            attachment_id=id,
            note_id=note_id,
            user_id=session.user_id,
            type=type,
            storage_path=remote_key,
            public_url=public_url,
            file_name=file_name or file.filename or safe_file_name,
            mime_type=resolved_mime_type,
            size_bytes=len(content),
            duration_ms=duration_ms,
            width=width,
            height=height,
            deleted=False,
            deleted_at=None,
            created_at=_to_utc(created_at),
            updated_at=_to_utc(updated_at),
            server_updated_at=now,
        )

        db.add(attachment)
    else:
        attachment = existing

        old_path = Path(attachment.storage_path)

        if old_path.exists() and old_path.is_file() and old_path != storage_path:
            old_path.unlink(missing_ok=True)

        attachment.note_id = note_id
        attachment.type = type
        attachment.storage_path = remote_key
        attachment.public_url = public_url
        attachment.file_name = file_name or file.filename or safe_file_name
        attachment.mime_type = resolved_mime_type
        attachment.size_bytes = len(content)
        attachment.duration_ms = duration_ms
        attachment.width = width
        attachment.height = height
        attachment.deleted = False
        attachment.deleted_at = None
        attachment.updated_at = _to_utc(updated_at)
        attachment.server_updated_at = now

    db.commit()
    db.refresh(attachment)

    user_event_logs(
        db=db,
        request=request,
        status_code=200,
        event="UPLOAD_NOTE_ATTACHMENT",
        user_id=session.user_id,
        session_id=session.id,
        device_id=session.device_id,
        platform=session.platform,
    )

    return _attachment_response(attachment)


@router.get("/{attachment_id}/file")
async def download_note_attachment_file(
    attachment_id: UUID,
    session: RegistrationSession = Depends(get_current_session),
    db: Session = Depends(get_db),
):
    attachment = (
        db.query(NoteAttachment)
        .filter(
            NoteAttachment.attachment_id == attachment_id,
            NoteAttachment.user_id == session.user_id,
            NoteAttachment.deleted.is_(False),
        )
        .first()
    )

    if attachment is None:
        raise HTTPException(status_code=404, detail="ATTACHMENT_NOT_FOUND")

    file_path = Path(attachment.storage_path)

    if not file_path.exists() or not file_path.is_file():
        raise HTTPException(status_code=404, detail="ATTACHMENT_FILE_NOT_FOUND")

    return FileResponse(
        path=file_path,
        media_type=attachment.mime_type or "application/octet-stream",
        filename=attachment.file_name or file_path.name,
    )


@router.delete("/{attachment_id}")
async def delete_note_attachment(
    request: Request,
    attachment_id: UUID,
    session: RegistrationSession = Depends(get_current_session),
    db: Session = Depends(get_db),
):
    attachment = (
        db.query(NoteAttachment)
        .filter(
            NoteAttachment.attachment_id == attachment_id,
            NoteAttachment.user_id == session.user_id,
        )
        .first()
    )

    if attachment is None:
        raise HTTPException(status_code=404, detail="ATTACHMENT_NOT_FOUND")

    now = datetime.now(timezone.utc)

    attachment.deleted = True
    attachment.deleted_at = now
    attachment.updated_at = now
    attachment.server_updated_at = now

    file_path = Path(attachment.storage_path)

    if file_path.exists() and file_path.is_file():
        file_path.unlink(missing_ok=True)

    db.commit()

    user_event_logs(
        db=db,
        request=request,
        status_code=200,
        event="DELETE_NOTE_ATTACHMENT",
        user_id=session.user_id,
        session_id=session.id,
        device_id=session.device_id,
        platform=session.platform,
    )

    return {"ok": True}


def _attachment_response(
    attachment: NoteAttachment,
) -> NoteAttachmentResponse:
    return NoteAttachmentResponse(
        id=attachment.attachment_id,
        note_id=attachment.note_id,
        type=attachment.type,
        remote_url=attachment.public_url,
        remote_key=attachment.storage_path,
        mime_type=attachment.mime_type,
        file_name=attachment.file_name,
        size_bytes=attachment.size_bytes,
        duration_ms=attachment.duration_ms,
        width=attachment.width,
        height=attachment.height,
        deleted=attachment.deleted,
        deleted_at=attachment.deleted_at,
        created_at=attachment.created_at,
        updated_at=attachment.updated_at,
        server_updated_at=attachment.server_updated_at,
    )


def _resolve_mime_type(
    file: UploadFile,
    mime_type: str | None,
) -> str:
    if mime_type is not None and mime_type.strip():
        return mime_type.strip().lower()

    if file.content_type is not None and file.content_type.strip():
        return file.content_type.strip().lower()

    return "application/octet-stream"


def _validate_mime_type(
    type: str,
    mime_type: str,
) -> None:
    if type == "image" and mime_type not in ALLOWED_IMAGE_MIME_TYPES:
        raise HTTPException(
            status_code=400,
            detail=f"UNSUPPORTED_IMAGE_MIME_TYPE:{mime_type}",
        )

    if type == "audio" and mime_type not in ALLOWED_AUDIO_MIME_TYPES:
        raise HTTPException(
            status_code=400,
            detail=f"UNSUPPORTED_AUDIO_MIME_TYPE:{mime_type}",
        )


def _validate_file_size(
    type: str,
    size_bytes: int,
) -> None:
    if size_bytes <= 0:
        raise HTTPException(status_code=400, detail="EMPTY_FILE")

    if type == "image" and size_bytes > MAX_IMAGE_SIZE_BYTES:
        raise HTTPException(status_code=413, detail="IMAGE_FILE_TOO_LARGE")

    if type == "audio" and size_bytes > MAX_AUDIO_SIZE_BYTES:
        raise HTTPException(status_code=413, detail="AUDIO_FILE_TOO_LARGE")


def _extension_for(
    type: str,
    mime_type: str,
    file_name: str | None,
) -> str:
    extension = EXTENSIONS_BY_MIME_TYPE.get(mime_type)

    if extension is not None:
        return extension

    if file_name is not None and "." in file_name:
        raw_extension = file_name.rsplit(".", 1)[-1].strip().lower()

        if raw_extension and raw_extension.isalnum() and len(raw_extension) <= 8:
            return raw_extension

    return "m4a" if type == "audio" else "jpg"


def _to_utc(value: datetime) -> datetime:
    if value.tzinfo is None:
        return value.replace(tzinfo=timezone.utc)

    return value.astimezone(timezone.utc)