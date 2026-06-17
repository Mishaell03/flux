CREATE TABLE user_event_logs (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT REFERENCES users(user_id) ON DELETE SET NULL,
    session_id BIGINT REFERENCES registration_sessions(id) ON DELETE SET NULL,
    event TEXT NOT NULL,
    request_method VARCHAR(10),
    request_path TEXT,
    status_code INT,
    device_id VARCHAR(64),
    platform VARCHAR(16),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX ix_user_event_logs_user_id ON user_event_logs(user_id);
CREATE INDEX ix_user_event_logs_session_id ON user_event_logs(session_id);
CREATE INDEX ix_user_event_logs_event ON user_event_logs(event);
CREATE INDEX ix_user_event_logs_created_at ON user_event_logs(created_at);