import 'package:drift/drift.dart';
import 'package:front/core/db/database.dart';
import 'package:front/core/db/database_provider.dart';
import 'package:uuid/uuid.dart';

class LocalNotesService {
  final AppDatabase db;

  LocalNotesService({
    AppDatabase? db,
  }) : db = db ?? DatabaseProvider.instance;

  Stream<List<NotesTableData>> watchNotes() {
    return (db.select(db.notesTable)
      ..where((tbl) => tbl.deleted.equals(false))
      ..orderBy([
            (tbl) => OrderingTerm(
          expression: tbl.updatedAt,
          mode: OrderingMode.desc,
        ),
      ]))
        .watch();
  }

  Future<List<NotesTableData>> getDirtyNotes() {
    return (db.select(db.notesTable)..where((tbl) => tbl.dirty.equals(true)))
        .get();
  }

  Future<void> createNote({
    String? title,
    String? content,
  }) async {
    final now = DateTime.now().toUtc();

    await db.into(db.notesTable).insert(
      NotesTableCompanion.insert(
        id: const Uuid().v4(),
        title: Value(title),
        content: Value(content),
        deleted: const Value(false),
        version: const Value(1),
        dirty: const Value(true),
        createdAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> updateNote({
    required String id,
    String? title,
    String? content,
  }) async {
    final note = await (db.select(db.notesTable)
      ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    if (note == null) return;

    final now = DateTime.now().toUtc();

    await (db.update(db.notesTable)..where((tbl) => tbl.id.equals(id))).write(
      NotesTableCompanion(
        title: Value(title),
        content: Value(content),
        version: Value(note.version + 1),
        dirty: const Value(true),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> deleteNote(String id) async {
    final note = await (db.select(db.notesTable)
      ..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();

    if (note == null) return;

    final now = DateTime.now().toUtc();

    await (db.update(db.notesTable)..where((tbl) => tbl.id.equals(id))).write(
      NotesTableCompanion(
        deleted: const Value(true),
        version: Value(note.version + 1),
        dirty: const Value(true),
        updatedAt: Value(now),
      ),
    );
  }

  Future<void> markNotesSynced(List<String> ids) async {
    if (ids.isEmpty) return;

    await (db.update(db.notesTable)..where((tbl) => tbl.id.isIn(ids))).write(
      const NotesTableCompanion(
        dirty: Value(false),
      ),
    );
  }
}