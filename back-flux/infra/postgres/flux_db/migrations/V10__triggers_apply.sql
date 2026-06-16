CREATE TRIGGER trg_notes_updated
BEFORE UPDATE ON notes
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();

CREATE TRIGGER trg_reminders_updated
BEFORE UPDATE ON reminders
FOR EACH ROW
EXECUTE FUNCTION set_updated_at();
