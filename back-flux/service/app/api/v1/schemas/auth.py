from typing import Literal

from pydantic import BaseModel, Field

class YandexLoginRequest(BaseModel):
    device_id: str = Field(
        ...,
        pattern=r'^[a-zA-Z0-9_-]+$',
        min_length=8,
        max_length=64,
        examples=["device_abc123"],
    )
    platform: Literal["android", "ios", "web", "windows", "linux", "macos"]
    language: str = Field(
        ...,
        pattern=r"^[a-z]{2,3}$",
        max_length=3,
        examples=["ru"],
    )

class YandexLoginResponse(BaseModel):
    url: str = Field(
        examples=['https://api.flux.pipipopi.online/auth/yandex/callback']
    )

class YandexCallbackRequest(BaseModel):
    state: str = Field(
        ...,
        min_length=10,
        max_length = 2048,
        examples=['eyJhbGciOiJIUzI1NiIsInR5.e...']
    )
    code: str = Field(
        ...,
        min_length=5,
        max_length = 512,
        examples=['uye6wbuvdvx3rh3h']
    )

class YandexCallbackResponse(BaseModel):
    token: str = Field(
        examples=['24lsPl3AouvV8OkYtWpOpo']
    )

