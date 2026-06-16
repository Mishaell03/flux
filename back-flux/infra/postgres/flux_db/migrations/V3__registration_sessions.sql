CREATE TABLE registration_sessions (
    id BIGSERIAL PRIMARY KEY,
    device_id VARCHAR(255) NOT NULL,
    user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    session_token_hash TEXT UNIQUE NOT NULL,
    refresh_token_hash TEXT,
    language VARCHAR(8),
    provider VARCHAR(20) REFERENCES providers(code) ON DELETE CASCADE,
    app_version VARCHAR(32),
    device_name VARCHAR(64),
    platform VARCHAR(16),
    is_verified BOOLEAN DEFAULT FALSE,
    revoked BOOLEAN DEFAULT FALSE,
    expires_at TIMESTAMPTZ NOT NULL,
    revoked_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX ix_sessions_user_id ON registration_sessions(user_id);
CREATE INDEX ix_sessions_device_id ON registration_sessions(device_id);
CREATE INDEX ix_sessions_token ON registration_sessions(session_token_hash);
CREATE INDEX ix_sessions_expires_at ON registration_sessions(expires_at);
CREATE INDEX ix_sessions_provider ON registration_sessions(provider);

CREATE INDEX ix_sessions_active
ON registration_sessions(user_id)
WHERE revoked_at IS NULL;