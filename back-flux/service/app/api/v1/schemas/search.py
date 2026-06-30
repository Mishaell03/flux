from datetime import datetime
from typing import Literal
from uuid import UUID

from pydantic import BaseModel


class SearchNoteItemResponse(BaseModel):
    id: UUID
    type: Literal["note", "reminder"]
    title: str | None = None
    description: str | None = None

    note_id: UUID | None = None
    remind_at: datetime | None = None
    repeat_rule: str | None = None


class SearchResponse(BaseModel):
    notes: list[SearchNoteItemResponse]