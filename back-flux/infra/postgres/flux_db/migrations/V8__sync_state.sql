CREATE TABLE sync_state (
    user_id BIGINT NOT NULL,
    session_id BIGINT NOT NULL,
    last_sync_at TIMESTAMPTZ,
    last_version INT DEFAULT 0,
    PRIMARY KEY (user_id, session_id)
);