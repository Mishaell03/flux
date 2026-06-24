from datetime import datetime
from typing import Literal
from uuid import UUID

from pydantic import BaseModel, Field

class SyncEntityVersion(BaseModel):
    id: UUID
    updated_at: datetime


class SyncStatusRequest(BaseModel):
    notes: list[SyncEntityVersion] = Field(default_factory=list)
    reminders: list[SyncEntityVersion] = Field(default_factory=list)


class SyncStatusItem(BaseModel):
    id: UUID
    is_update_required: bool
    server_has_latest_version: bool


class SyncStatusResponse(BaseModel):
    notes: list[SyncStatusItem]
    reminders: list[SyncStatusItem]


class SyncPushNote(BaseModel):
    id: UUID
    title: str | None = None
    content: str | None = None
    deleted: bool = False
    deleted_at: datetime | None = None
    created_at: datetime | None = None
    updated_at: datetime


class SyncPushReminder(BaseModel):
    id: UUID
    note_id: UUID | None = None
    remind_at: datetime
    repeat_rule: str | None = None
    is_done: bool = False
    deleted: bool = False
    created_at: datetime | None = None
    updated_at: datetime


class SyncPushRequest(BaseModel):
    notes: list[SyncPushNote] = Field(default_factory=list)
    reminders: list[SyncPushReminder] = Field(default_factory=list)


class SyncPushResultItem(BaseModel):
    id: UUID
    action: Literal["created", "updated", "skipped", "rejected"]
    server_updated_at: datetime | None = None
    message: str | None = None


class SyncPushResponse(BaseModel):
    notes: list[SyncPushResultItem]
    reminders: list[SyncPushResultItem]

class SyncPullRequest(BaseModel):
    notes: list[UUID] = Field(default_factory=list)
    reminders: list[UUID] = Field(default_factory=list)

class SyncPullNote(BaseModel):
    id: UUID
    title: str | None = None
    content: str | None = None
    deleted: bool = False
    deleted_at: datetime | None = None
    created_at: datetime
    updated_at: datetime

class SyncPullReminder(BaseModel):
    id: UUID
    note_id: UUID | None = None
    remind_at: datetime
    repeat_rule: str | None = None
    is_done: bool = False
    deleted: bool = False
    created_at: datetime
    updated_at: datetime

class SyncPullResponse(BaseModel):
    notes: list[SyncPullNote]
    reminders: list[SyncPullReminder]