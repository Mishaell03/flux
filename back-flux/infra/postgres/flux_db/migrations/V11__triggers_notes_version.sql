CREATE OR REPLACE FUNCTION inc_version()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.title IS DISTINCT FROM OLD.title
       OR NEW.content IS DISTINCT FROM OLD.content THEN
        NEW.version = OLD.version + 1;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_notes_version
BEFORE UPDATE ON notes
FOR EACH ROW
EXECUTE FUNCTION inc_version();