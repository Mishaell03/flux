import httpx
from app.core.config import settings

def get_token(code: str) -> str:
    r = httpx.post(
        "https://oauth.yandex.ru/token",
        data={
            "grant_type": "authorization_code",
            "code": code,
            "client_id": settings.yandex_client_id,
            "client_secret": settings.yandex_client_secret,
        },
        timeout=10,
    )
    return r.json()["access_token"]

def get_profile(token: str) -> dict:
    r = httpx.get(
        "https://login.yandex.ru/info",
        headers={"Authorization": f"OAuth {token}"},
        params={"format": "json"},
        timeout=10,
    )
    return r.json()