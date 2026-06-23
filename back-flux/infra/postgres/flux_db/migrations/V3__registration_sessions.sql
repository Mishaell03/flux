CREATE TABLE registration_sessions (
    id BIGSERIAL PRIMARY KEY,
    device_id VARCHAR(255) NOT NULL,
    user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    session_token VARCHAR(255) UNIQUE,
    language VARCHAR(3),
    provider VARCHAR(20) REFERENCES providers(code) ON DELETE CASCADE,
    app_version VARCHAR(32),
    device_name VARCHAR(32),
    platform VARCHAR(10),
    is_verified BOOLEAN DEFAULT FALSE,
    expires_at TIMESTAMPTZ NOT NULL,
    revoked_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX ix_sessions_user_id ON registration_sessions(user_id);
CREATE INDEX ix_sessions_device_id ON registration_sessions(device_id);
CREATE INDEX ix_sessions_token ON registration_sessions(session_token);
CREATE INDEX ix_sessions_expires_at ON registration_sessions(expires_at);
CREATE INDEX ix_sessions_provider ON registration_sessions(provider);