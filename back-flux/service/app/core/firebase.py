import firebase_admin
from firebase_admin import credentials

from app.core.config import Settings


def init_firebase() -> None:
    if firebase_admin._apps:
        return

    if not Settings.firebase_credentials:
        raise RuntimeError("Settings.firebase_credentials is not set")

    cred = credentials.Certificate(Settings.firebase_credentials)
    firebase_admin.initialize_app(cred)