from pydantic import BaseModel, Field


class UserProfileResponse(BaseModel):
    name: str | None = Field(
        default=None,
        examples=["Alex"],
    )
    phone: str | None = Field(
        default=None,
        examples=["+79990000000"],
    )
    email: str | None = Field(
        default=None,
        examples=["alex@mail.com"],
    )
    image: str | None = Field(
        default=None,
        examples=["https://api.example.com/uploads/avatar.png"],
    )

    notes_count: int = Field(
        examples=[12],
    )
    reminders_count: int = Field(
        examples=[4],
    )
    note_links_count: int = Field(
        examples=[8],
    )
    sessions_count: int = Field(
        examples=[2],
    )

    session_provider: str | None = Field(
        default=None,
        examples=["yandex"],
    )

    is_verified: bool = Field(
        default=False,
        examples=[True],
    )