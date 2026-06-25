import 'dart:async';

import 'package:drift/drift.dart';
import 'package:front/core/db/database_provider.dart';
import 'package:front/futures/notes/models/notes_list_data.dart';

class NotesRepository {
  final db = DatabaseProvider.instance;

  Future<NotesListData> getListData() async {
    final notes = await (db.select(db.notesTable)
          ..where((tbl) => tbl.deleted.equals(false))
          ..orderBy([
            (tbl) => OrderingTerm(
                  expression: tbl.updatedAt,
                  mode: OrderingMode.desc,
                ),
          ]))
        .get();

    final reminders = await (db.select(db.remindersTable)
          ..where((tbl) => tbl.deleted.equals(false))
          ..orderBy([
            (tbl) => OrderingTerm(
                  expression: tbl.remindAt,
                  mode: OrderingMode.asc,
                ),
          ]))
        .get();

    final reminderNoteIds = reminders
        .where((reminder) => reminder.noteId != null)
        .map((reminder) => reminder.noteId!)
        .toSet();

    final visibleNotes =
        notes.where((note) => !reminderNoteIds.contains(note.id)).toList();

    final notesById = {
      for (final note in notes) note.id: note,
    };

    return NotesListData(
      notes: visibleNotes.map((note) {
        return NoteListItem(
          id: note.id,
          title: _safeTitle(note.title),
          content: _safeContent(note.content),
          updatedAt: note.updatedAt,
        );
      }).toList(),
      reminders: reminders.map((reminder) {
        final linkedNote =
            reminder.noteId == null ? null : notesById[reminder.noteId];

        return ReminderListItem(
          id: reminder.id,
          noteId: reminder.noteId,
          title: _safeTitle(linkedNote?.title),
          remindAt: reminder.remindAt,
          isDone: reminder.isDone,
        );
      }).toList(),
    );
  }

  Stream<NotesListData> watchListData() {
    final controller = StreamController<NotesListData>();

    final subscriptions = <StreamSubscription>[];

    Future<void> emit() async {
      if (controller.isClosed) return;

      final data = await getListData();

      if (!controller.isClosed) {
        controller.add(data);
      }
    }

    controller.onListen = () {
      subscriptions.addAll([
        db.select(db.notesTable).watch().listen((_) => emit()),
        db.select(db.remindersTable).watch().listen((_) => emit()),
      ]);

      emit();
    };

    controller.onCancel = () async {
      for (final sub in subscriptions) {
        await sub.cancel();
      }
    };

    return controller.stream;
  }

  String _safeTitle(String? value) {
    final text = value?.trim();

    if (text == null || text.isEmpty) {
      return 'Untitled';
    }

    return text;
  }

  String _safeContent(String? value) {
    final text = value?.trim();

    if (text == null || text.isEmpty) {
      return 'No content yet';
    }

    return text;
  }
}
