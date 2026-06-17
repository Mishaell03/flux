CREATE TABLE reminders (
    reminder_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id BIGINT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    note_id UUID REFERENCES notes(note_id) ON DELETE CASCADE,
    remind_at TIMESTAMPTZ NOT NULL,
    repeat_rule TEXT,
    is_done BOOLEAN DEFAULT FALSE,
    deleted BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX ix_reminders_user_id ON reminders(user_id);
CREATE INDEX ix_reminders_remind_at ON reminders(remind_at);
CREATE INDEX ix_reminders_note_id ON reminders(note_id);
CREATE INDEX ix_reminders_active ON reminders(user_id, remind_at) WHERE is_done = FALSE AND deleted = FALSE;