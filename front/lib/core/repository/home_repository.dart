import 'dart:async';

import 'package:front/core/db/database_provider.dart';

class HomeRepository {
  final db = DatabaseProvider.instance;

  Future<Map<String, int>> getLocalStats() async {
    final notes = await db.select(db.notesTable).get();
    final reminders = await db.select(db.remindersTable).get();
    final links = await db.select(db.noteLinksTable).get();

    return {
      'notes': notes.where((note) => !note.deleted).length,
      'reminders': reminders.where((reminder) => !reminder.deleted).length,
      'links': links.length,
    };
  }

  Stream<Map<String, int>> watchStats() {
    final controller = StreamController<Map<String, int>>.broadcast();

    Future<void> emit() async {
      if (controller.isClosed) return;

      final stats = await getLocalStats();

      if (!controller.isClosed) {
        controller.add(stats);
      }
    }

    final notesSub = db.select(db.notesTable).watch().listen((_) {
      emit();
    });

    final remindersSub = db.select(db.remindersTable).watch().listen((_) {
      emit();
    });

    final linksSub = db.select(db.noteLinksTable).watch().listen((_) {
      emit();
    });

    emit();

    controller.onCancel = () async {
      await notesSub.cancel();
      await remindersSub.cancel();
      await linksSub.cancel();
    };

    return controller.stream;
  }
}