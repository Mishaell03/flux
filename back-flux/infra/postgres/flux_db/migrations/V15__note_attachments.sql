CREATE TABLE note_attachments (
    attachment_id UUID PRIMARY KEY,
    note_id UUID NOT NULL REFERENCES notes(note_id) ON DELETE CASCADE,
    user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,

    type VARCHAR(20) NOT NULL,
    storage_path TEXT NOT NULL,
    public_url TEXT,

    file_name TEXT,
    mime_type TEXT,
    size_bytes BIGINT,

    duration_ms INTEGER,
    width INTEGER,
    height INTEGER,

    deleted BOOLEAN NOT NULL DEFAULT FALSE,
    deleted_at TIMESTAMP WITH TIME ZONE,

    created_at TIMESTAMP WITH TIME ZONE NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL,
    server_updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),

    CONSTRAINT note_attachments_type_check CHECK (type IN ('image', 'audio'))
);

CREATE INDEX ix_note_attachments_user_id ON note_attachments(user_id);
CREATE INDEX ix_note_attachments_note_id ON note_attachments(note_id);
CREATE INDEX ix_note_attachments_updated_at ON note_attachments(updated_at);
CREATE INDEX ix_note_attachments_deleted ON note_attachments(deleted);