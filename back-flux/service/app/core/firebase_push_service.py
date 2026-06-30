from firebase_admin import messaging

def send_push_to_tokens(
        tokens: list[str],
        title: str,
        body: str,
        data: dict[str, str] | None = None,
) -> dict:
    if not tokens:
        return {
            "sent": 0,
            "failed": 0,
        }

    sent = 0
    failed = 0

    for i in range(0, len(tokens), 500):
        chunk = tokens[i:i + 500]

        message = messaging.MulticastMessage(
            tokens=chunk,
            notification=messaging.Notification(
                title=title,
                body=body,
            ),
            data=data or {},
        )

        response = messaging.send_each_for_multicast(message)

        sent += response.success_count
        failed += response.failure_count

    return {
        "sent": sent,
        "failed": failed,
    }