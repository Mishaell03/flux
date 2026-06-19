from pydantic import BaseModel
from uuid import UUID
from datetime import datetime


class NoteLinksPushItem(BaseModel):
    to_note_id: UUID
    weight: int = 1

class NoteLinksPushRequest(BaseModel):
    from_note_id: UUID
    links: list[NoteLinksPushItem]

class NoteLinksItemResponse(BaseModel):
    from_note_id: UUID
    to_note_id: UUID
    weight: int
    created_at: datetime

class NoteLinksGetResponse(BaseModel):
    links: list[NoteLinksItemResponse]