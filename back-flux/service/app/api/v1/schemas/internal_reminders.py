from datetime import datetime
from uuid import UUID

from pydantic import BaseModel, Field


class ReminderFireRequest(BaseModel):
    reminder_id: UUID
    user_id: int
    note_id: UUID | None = None
    remind_at: datetime
    updated_at: datetime


class ReminderFireResponse(BaseModel):
    success: bool
    sent: int = Field(default=0)
    failed: int = Field(default=0)
    reason: str | None = None