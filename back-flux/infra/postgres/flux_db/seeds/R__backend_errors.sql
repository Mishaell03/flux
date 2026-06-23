INSERT INTO backend_errors (code, http_status) VALUES
    ('YANDEX_LOGIN_REUSED', 200),
    ('STATE_EXPIRED', 401),
    ('SESSION_NOT_FOUND', 404),
    ('YANDEX_NO_EMAIL', 400),
    ('INVALID_SESSION', 401),
    ('RECENT_SESSION', 429),
    ('YANDEX_TIMEOUT', 504),
    ('YANDEX_UNAVAILABLE', 503),
    ('YANDEX_AUTH_FAILED', 400)
ON CONFLICT (code) DO NOTHING;

INSERT INTO backend_errors_localization (code, language, message) VALUES
    ('YANDEX_LOGIN_REUSED', 'ru', 'Сессия входа уже существует и ещё действительна'),
    ('YANDEX_LOGIN_REUSED', 'en', 'Login session already exists and is still valid'),

    ('STATE_EXPIRED', 'ru', 'Токен состояния OAuth истёк'),
    ('STATE_EXPIRED', 'en', 'OAuth state token has expired'),

    ('SESSION_NOT_FOUND', 'ru', 'Сессия входа не найдена'),
    ('SESSION_NOT_FOUND', 'en', 'Login session not found'),

    ('YANDEX_NO_EMAIL', 'ru', 'Аккаунт Яндекс не предоставляет email'),
    ('YANDEX_NO_EMAIL', 'en', 'Yandex account does not provide an email address'),

    ('INVALID_SESSION', 'en', 'Invalid session'),
    ('INVALID_SESSION', 'ru', 'Недействительная сессия'),

    ('RECENT_SESSION', 'en', 'Session was created recently. Please try again later'),
    ('RECENT_SESSION', 'ru', 'Сессия была создана недавно. Попробуйте позже'),

     ('YANDEX_TIMEOUT', 'ru', 'Яндекс не ответил вовремя. Попробуйте ещё раз.'),
    ('YANDEX_TIMEOUT', 'en', 'Yandex did not respond in time. Please try again.'),

    ('YANDEX_UNAVAILABLE', 'ru', 'Сервис Яндекса временно недоступен. Попробуйте позже.'),
    ('YANDEX_UNAVAILABLE', 'en', 'Yandex service is temporarily unavailable. Please try again later.'),

    ('YANDEX_AUTH_FAILED', 'ru', 'Не удалось авторизоваться через Яндекс. Попробуйте войти ещё раз.'),
    ('YANDEX_AUTH_FAILED', 'en', 'Failed to authenticate with Yandex. Please try signing in again.')
ON CONFLICT (code, language) DO NOTHING;