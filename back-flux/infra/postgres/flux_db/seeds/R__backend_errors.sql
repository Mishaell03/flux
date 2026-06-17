INSERT INTO backend_errors (code, http_status) VALUES
    ('YANDEX_LOGIN_REUSED', 200),
    ('STATE_EXPIRED', 401),
    ('SESSION_NOT_FOUND', 404),
    ('YANDEX_NO_EMAIL', 400)
ON CONFLICT (code) DO NOTHING;

INSERT INTO backend_errors_localization (code, language, message) VALUES
    ('YANDEX_LOGIN_REUSED', 'ru', 'Сессия входа уже существует и ещё действительна'),
    ('YANDEX_LOGIN_REUSED', 'en', 'Login session already exists and is still valid'),

    ('STATE_EXPIRED', 'ru', 'Токен состояния OAuth истёк'),
    ('STATE_EXPIRED', 'en', 'OAuth state token has expired'),

    ('SESSION_NOT_FOUND', 'ru', 'Сессия входа не найдена'),
    ('SESSION_NOT_FOUND', 'en', 'Login session not found'),

    ('YANDEX_NO_EMAIL', 'ru', 'Аккаунт Яндекс не предоставляет email'),
    ('YANDEX_NO_EMAIL', 'en', 'Yandex account does not provide an email address')
ON CONFLICT (code, language) DO NOTHING;