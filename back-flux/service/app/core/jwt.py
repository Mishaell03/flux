import jwt
from datetime import datetime, timedelta, timezone
from app.core.config import settings

def create_state(device_id: str, platform: str, session_id: str) -> str:
    return jwt.encode(
        {
            "device_id": device_id,
            "platform": platform,
            "session_id": session_id,
            "exp": datetime.now(timezone.utc) + timedelta(minutes=15),
        },
        settings.secret,
        algorithm="HS256",
    )


def decode_state(state: str) -> dict:
    return jwt.decode(
        state,
        settings.secret,
        algorithms=["HS256"],
    )