from datetime import datetime
from typing import Literal
from uuid import UUID

from pydantic import BaseModel


class NoteAttachmentResponse(BaseModel):
    id: UUID
    note_id: UUID
    type: Literal["image", "audio"]

    remote_url: str | None = None
    remote_key: str | None = None

    mime_type: str | None = None
    file_name: str | None = None
    size_bytes: int | None = None

    duration_ms: int | None = None
    width: int | None = None
    height: int | None = None

    deleted: bool
    deleted_at: datetime | None = None

    created_at: datetime
    updated_at: datetime
    server_updated_at: datetime


class NoteAttachmentsListResponse(BaseModel):
    attachments: list[NoteAttachmentResponse]