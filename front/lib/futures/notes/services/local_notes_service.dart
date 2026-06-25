import 'package:drift/drift.dart';
import 'package:front/core/db/database.dart';
import 'package:front/core/db/database_provider.dart';
import 'package:front/futures/notes/models/notes_list_data.dart';
import 'package:uuid/uuid.dart';

class LocalNotesService {
  final AppDatabase db;

  LocalNotesService({
    AppDatabase? db,
  }) : db = db ?? DatabaseProvider.instance;

  Future<NoteListItem?> getNoteById(String id) async {
    final note = await (db.select(db.notesTable)
          ..where(
            (tbl) => tbl.id.equals(id) & tbl.deleted.equals(false),
          )
          ..limit(1))
        .getSingleOrNull();

    if (note == null) return null;

    return NoteListItem(
      id: note.id,
      title: note.title ?? 'Untitled',
      content: note.content ?? '',
      updatedAt: note.updatedAt,
    );
  }

  Future<String> createNote({
    required String title,
    required String content,
  }) async {
    final id = const Uuid().v4();
    final now = DateTime.now().toUtc();

    await db.into(db.notesTable).insert(
          NotesTableCompanion.insert(
            id: id,
            title: Value(_nullableText(title)),
            content: Value(_nullableText(content)),
            deleted: const Value(false),
            dirty: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
        );

    return id;
  }

  Future<void> updateNote({
    required String id,
    required String title,
    required String content,
  }) async {
    final current = await (db.select(db.notesTable)
          ..where(
            (tbl) => tbl.id.equals(id) & tbl.deleted.equals(false),
          )
          ..limit(1))
        .getSingleOrNull();

    if (current == null) {
      throw StateError('Note not found: $id');
    }

    final now = DateTime.now().toUtc();

    await (db.update(db.notesTable)
          ..where(
            (tbl) => tbl.id.equals(id) & tbl.deleted.equals(false),
          ))
        .write(
      NotesTableCompanion(
        title: Value(_nullableText(title)),
        content: Value(_nullableText(content)),
        dirty: const Value(true),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> destroyNote({
    required String id,
  }) async {
    final current = await (db.select(db.notesTable)
          ..where(
            (tbl) => tbl.id.equals(id) & tbl.deleted.equals(false),
          )
          ..limit(1))
        .getSingleOrNull();

    if (current == null) {
      throw StateError('Note not found: $id');
    }

    final now = DateTime.now().toUtc();

    await (db.update(db.notesTable)
          ..where(
            (tbl) => tbl.id.equals(id) & tbl.deleted.equals(false),
          ))
        .write(
      NotesTableCompanion(
        deleted: const Value(true),
        deletedAt: Value(now),
        dirty: const Value(true),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> destroyReminder({
    required String id,
  }) async {
    final current = await (db.select(db.remindersTable)
          ..where(
            (tbl) => tbl.id.equals(id) & tbl.deleted.equals(false),
          )
          ..limit(1))
        .getSingleOrNull();

    if (current == null) {
      throw StateError('Reminder not found: $id');
    }

    final now = DateTime.now().toUtc();

    await (db.update(db.remindersTable)
          ..where(
            (tbl) => tbl.id.equals(id) & tbl.deleted.equals(false),
          ))
        .write(
      RemindersTableCompanion(
        deleted: const Value(true),
        dirty: const Value(true),
        updatedAt: Value(now),
      ),
    );
  }

  String? _nullableText(String value) {
    final text = value.trim();

    if (text.isEmpty) return null;

    return text;
  }
}
