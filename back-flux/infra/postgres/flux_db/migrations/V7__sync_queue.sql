CREATE TABLE sync_queue (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id BIGINT NOT NULL REFERENCES users(user_id),
    session_id BIGINT REFERENCES registration_sessions(id),

    entity_type TEXT NOT NULL,
    entity_id UUID NOT NULL,
    operation TEXT NOT NULL,

    payload JSONB,

    status TEXT DEFAULT 'pending',
    retry_count INT DEFAULT 0,
    last_error TEXT,

    created_at TIMESTAMPTZ DEFAULT NOW(),

    CONSTRAINT sync_queue_status_chk
    CHECK (status IN ('pending', 'processing', 'failed', 'done'))
);

CREATE INDEX ix_sync_user ON sync_queue(user_id);
CREATE INDEX ix_sync_status ON sync_queue(status);
CREATE INDEX ix_sync_session ON sync_queue(session_id);
CREATE INDEX ix_sync_created ON sync_queue(created_at);