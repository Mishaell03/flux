from datetime import datetime

from pydantic import BaseModel, Field


class SessionResponse(BaseModel):
    is_session_need_update: bool = Field(
        ...,
        examples=[True],
    )

class SessionRefreshResponse(BaseModel):
    token: str = Field(
        examples=['24lsPl3AouvV8OkYtWpOpo']
    )


class SessionListItem(BaseModel):
    id: int
    device_id: str
    device_name: str | None = None
    platform: str | None = None
    app_version: str | None = None
    provider: str | None = None
    is_current: bool
    created_at: datetime
    expires_at: datetime


class SessionListResponse(BaseModel):
    sessions: list[SessionListItem]
