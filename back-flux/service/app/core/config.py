import os
from pathlib import Path

from dotenv import load_dotenv


BASE_DIR = Path(__file__).resolve().parents[3]
load_dotenv(BASE_DIR / ".env")
load_dotenv()


class Settings:
    secret: str = os.getenv("SECRET", "dev-secret")

    internal_api_token: str = os.getenv("INTERNAL_API_TOKEN")
    n8n_reminder_webhook: str = os.getenv("N8N_REMINDER_WEBHOOK")

    # DATABASE
    db_host: str = os.getenv("DB_HOST", "127.0.0.1")
    db_port: int = int(os.getenv("DB_PORT", "5432"))
    db_name: str = os.getenv("DB_NAME", "flux_db")
    db_user: str = os.getenv("DB_USER", "root")
    db_password: str = os.getenv("DB_PASSWORD", "root")

    # API
    api_host: str = os.getenv("API_HOST", "127.0.0.1")

    api_port: int = int(os.getenv("API_PORT", "8000"))

    image_base_endpoint: str = os.getenv("IMAGE_BASE_ENDPOINT", "")

    api_reload: bool = (
        os.getenv("API_RELOAD", "false")
        .strip()
        .lower()
        in {
            "1",
            "true",
            "yes",
            "on",
        }
    )

    yandex_client_id: str = os.getenv("YANDEX_CLIENT_ID")
    yandex_client_secret: str = os.getenv("YANDEX_CLIENT_SECRET")
    yandex_redirect_url: str = os.getenv("YANDEX_REDIRECT_URI")
    yandex_redirect_web: str = os.getenv("YANDEX_REDIRECT_WEB")
    yandex_redirect_mobile: str = os.getenv("YANDEX_REDIRECT_MOBILE")

    firebase_credentials: str = os.getenv('FIREBASE_CREDENTIALS')

    # DATABASE URL
    @property
    def database_url(self) -> str:
        return (
            f"postgresql+psycopg2://"
            f"{self.db_user}:{self.db_password}"
            f"@{self.db_host}:{self.db_port}"
            f"/{self.db_name}"
        )

settings = Settings()
