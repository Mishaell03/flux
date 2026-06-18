from pydantic import BaseModel, Field


class SessionResponse(BaseModel):
    is_session_need_update: bool = Field(
        ...,
        examples=[True],
    )
