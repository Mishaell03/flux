CREATE TABLE yandex_login_sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id BIGINT REFERENCES users(user_id),
    device_id VARCHAR(64) NOT NULL,
    platform VARCHAR(16) NOT NULL,
    language VARCHAR(3) NOT NULL,
    app_version VARCHAR(32),
    device_name VARCHAR(32),
    expires_at TIMESTAMPTZ NOT NULL,
    used_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);