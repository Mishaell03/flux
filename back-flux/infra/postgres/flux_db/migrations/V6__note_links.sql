CREATE TABLE note_links (
    link_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    from_note_id UUID NOT NULL REFERENCES notes(note_id) ON DELETE CASCADE,
    to_note_id UUID NOT NULL REFERENCES notes(note_id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE note_links
ADD CONSTRAINT note_links_unique UNIQUE(from_note_id, to_note_id);

CREATE INDEX ix_links_from ON note_links(from_note_id);
CREATE INDEX ix_links_to ON note_links(to_note_id);