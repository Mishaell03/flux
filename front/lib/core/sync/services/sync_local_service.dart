import 'package:drift/drift.dart';
import 'package:front/core/db/database.dart';
import 'package:front/core/db/database_provider.dart';
import 'package:front/core/sync/models/note_link_sync.dart';
import 'package:front/core/sync/models/sync_pull.dart';
import 'package:front/core/sync/models/sync_status.dart';

class SyncLocalService {
  final AppDatabase db;

  SyncLocalService({
    AppDatabase? db,
  }) : db = db ?? DatabaseProvider.instance;

  Future<List<SyncEntityVersion>> getNoteVersions() async {
    final notes = await db.select(db.notesTable).get();

    return notes.map((note) {
      return SyncEntityVersion(
        id: note.id,
        updatedAt: note.updatedAt,
      );
    }).toList();
  }

  Future<List<SyncEntityVersion>> getReminderVersions() async {
    final reminders = await db.select(db.remindersTable).get();

    return reminders.map((reminder) {
      return SyncEntityVersion(
        id: reminder.id,
        updatedAt: reminder.updatedAt,
      );
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getDirtyNotesPayloadByIds(
    Set<String> ids,
  ) async {
    if (ids.isEmpty) return [];

    final notes = await (db.select(db.notesTable)
          ..where(
            (tbl) => tbl.id.isIn(ids),
          ))
        .get();

    return notes.map(_noteToJson).toList();
  }

  Future<List<Map<String, dynamic>>> getDirtyRemindersPayloadByIds(
    Set<String> ids,
  ) async {
    if (ids.isEmpty) return [];

    final reminders = await (db.select(db.remindersTable)
          ..where(
            (tbl) => tbl.id.isIn(ids),
          ))
        .get();

    return reminders.map(_reminderToJson).toList();
  }

  Future<void> markNotesSynced(List<String> ids) async {
    if (ids.isEmpty) return;

    await (db.update(db.notesTable)..where((tbl) => tbl.id.isIn(ids))).write(
      const NotesTableCompanion(
        dirty: Value(false),
      ),
    );
  }

  Future<void> markRemindersSynced(List<String> ids) async {
    if (ids.isEmpty) return;

    await (db.update(db.remindersTable)..where((tbl) => tbl.id.isIn(ids)))
        .write(
      const RemindersTableCompanion(
        dirty: Value(false),
      ),
    );
  }

  Future<void> replaceNoteLinks(List<NoteLinkSyncItem> links) async {
    final companions = links.map((link) {
      return NoteLinksTableCompanion.insert(
        fromId: link.fromNoteId,
        toId: link.toNoteId,
        weight: Value(link.weight),
        createdAt: link.createdAt,
        dirty: const Value(false),
      );
    }).toList();

    await db.transaction(() async {
      await db.delete(db.noteLinksTable).go();

      if (companions.isNotEmpty) {
        await db.batch((batch) {
          batch.insertAllOnConflictUpdate(
            db.noteLinksTable,
            companions,
          );
        });
      }
    });
  }

  Map<String, dynamic> _noteToJson(NotesTableData note) {
    return {
      'id': note.id,
      'title': note.title,
      'content': note.content,
      'deleted': note.deleted,
      'deleted_at': note.deletedAt?.toUtc().toIso8601String(),
      'created_at': note.createdAt.toUtc().toIso8601String(),
      'updated_at': note.updatedAt.toUtc().toIso8601String(),
    };
  }

  Map<String, dynamic> _reminderToJson(RemindersTableData reminder) {
    return {
      'id': reminder.id,
      'note_id': reminder.noteId,
      'remind_at': reminder.remindAt.toUtc().toIso8601String(),
      'repeat_rule': reminder.repeatRule,
      'is_done': reminder.isDone,
      'deleted': reminder.deleted,
      'created_at': reminder.createdAt.toUtc().toIso8601String(),
      'updated_at': reminder.updatedAt.toUtc().toIso8601String(),
    };
  }

  Future<void> applyPulledNotes(List<SyncPullNote> notes) async {
    if (notes.isEmpty) return;

    final companions = notes.map((note) {
      return NotesTableCompanion.insert(
        id: note.id,
        title: Value(note.title),
        content: Value(note.content),
        deleted: Value(note.deleted),
        deletedAt: Value(note.deletedAt),
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
        dirty: const Value(false),
      );
    }).toList();

    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.notesTable,
        companions,
      );
    });
  }

  Future<void> applyPulledReminders(List<SyncPullReminder> reminders) async {
    if (reminders.isEmpty) return;

    final companions = reminders.map((reminder) {
      return RemindersTableCompanion.insert(
        id: reminder.id,
        noteId: Value(reminder.noteId),
        remindAt: reminder.remindAt,
        repeatRule: Value(reminder.repeatRule),
        isDone: Value(reminder.isDone),
        deleted: Value(reminder.deleted),
        createdAt: reminder.createdAt,
        updatedAt: reminder.updatedAt,
        dirty: const Value(false),
      );
    }).toList();

    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.remindersTable,
        companions,
      );
    });
  }

  Future<List<NoteLinkSyncItem>> buildLinksFromNote({
    required String fromNoteId,
    required String content,
  }) async {
    final internalLinks = RegExp(r'\[\[([^\]]+)\]\]')
        .allMatches(content)
        .map((e) => _linkTarget(e.group(1)!))
        .where((target) => target.isNotEmpty)
        .toSet();

    if (internalLinks.isEmpty) return [];

    final notes = await (db.select(db.notesTable)
          ..where((tbl) => tbl.deleted.equals(false)))
        .get();

    final titleToId = {
      for (final note in notes)
        if (note.title != null && note.title!.trim().isNotEmpty)
          note.title!.trim(): note.id,
    };

    final links = <NoteLinkSyncItem>[];

    for (final target in internalLinks) {
      final toNoteId = _looksLikeUuid(target) ? target : titleToId[target];

      if (toNoteId == null || toNoteId == fromNoteId) continue;

      links.add(NoteLinkSyncItem(
        fromNoteId: fromNoteId,
        toNoteId: toNoteId,
        weight: 1,
        createdAt: DateTime.now().toUtc(),
      ));
    }

    return links;
  }

  String _linkTarget(String rawLink) {
    final parts = rawLink
        .split('|')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '';

    for (final part in parts) {
      if (_isUrl(part)) return part;
    }

    return parts.first;
  }

  bool _isUrl(String value) {
    final text = value.trim().toLowerCase();

    return text.startsWith('http://') || text.startsWith('https://');
  }

  bool _looksLikeUuid(String value) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(value);
  }
}
