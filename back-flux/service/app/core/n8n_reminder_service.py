import httpx
from app.core.config import settings
from app.db.models import Reminder

def send_reminder_to_n8n(reminder: Reminder) -> bool:
    if not settings.n8n_reminder_webhook:
        return False

    if reminder.deleted or reminder.is_done:
        return False

    payload = {
        "reminder_id": str(reminder.reminder_id),
        "user_id": reminder.user_id,
        "note_id": str(reminder.note_id) if reminder.note_id else None,
        "remind_at": reminder.remind_at.isoformat(),
        "updated_at": reminder.updated_at.isoformat(),
    }

    try:
        response = httpx.post(
            settings.n8n_reminder_webhook,
            json=payload,
            timeout=5,
        )
        response.raise_for_status()
        return True
    except httpx.HTTPError:
        return False