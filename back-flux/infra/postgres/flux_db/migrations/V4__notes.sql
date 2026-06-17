CREATE TABLE notes (
    note_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    title TEXT,
    content TEXT,
    deleted BOOLEAN DEFAULT FALSE,
    deleted_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX ix_notes_user_id ON notes(user_id);
CREATE INDEX ix_notes_updated_at ON notes(updated_at);
CREATE INDEX ix_notes_deleted ON notes(deleted);

CREATE INDEX ix_notes_title_gin ON notes USING GIN (to_tsvector('simple', title));
CREATE INDEX ix_notes_content_gin ON notes USING GIN (to_tsvector('simple', content));