import httpx

from app.core.config import settings


class YandexOAuthBadResponse(Exception):
    pass


YANDEX_TIMEOUT = httpx.Timeout(
    timeout=20.0,
    connect=20.0,
    read=20.0,
    write=10.0,
    pool=10.0,
)


def get_token(code: str) -> str:
    response = httpx.post(
        "https://oauth.yandex.ru/token",
        data={
            "grant_type": "authorization_code",
            "code": code,
            "client_id": settings.yandex_client_id,
            "client_secret": settings.yandex_client_secret,
        },
        headers={
            "Content-Type": "application/x-www-form-urlencoded",
        },
        timeout=YANDEX_TIMEOUT,
    )

    response.raise_for_status()

    data = response.json()
    access_token = data.get("access_token")

    if not access_token:
        raise YandexOAuthBadResponse("Yandex token response has no access_token")

    return access_token


def get_profile(token: str) -> dict:
    response = httpx.get(
        "https://login.yandex.ru/info",
        headers={
            "Authorization": f"OAuth {token}",
        },
        params={
            "format": "json",
        },
        timeout=YANDEX_TIMEOUT,
    )

    response.raise_for_status()

    data = response.json()

    if not isinstance(data, dict):
        raise YandexOAuthBadResponse("Yandex profile response is not dict")

    return data