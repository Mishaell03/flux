import 'dart:async';

import 'package:front/core/db/database_provider.dart';
import 'package:front/futures/profile/models/local_sync_status.dart';

class LocalSyncStatusService {
  final db = DatabaseProvider.instance;

  Future<LocalSyncStatus> load() async {
    final notes = await db.select(db.notesTable).get();
    final reminders = await db.select(db.remindersTable).get();
    final links = await db.select(db.noteLinksTable).get();

    final activeNotes = notes.where((note) => !note.deleted).length;
    final activeReminders =
        reminders.where((reminder) => !reminder.deleted).length;
    final dirtyNotes = notes.where((note) => note.dirty).length;
    final dirtyReminders = reminders.where((reminder) => reminder.dirty).length;
    final dirtyLinks = links.where((link) => link.dirty).length;

    return LocalSyncStatus(
      localItemsCount: activeNotes + activeReminders + links.length,
      pendingItemsCount: dirtyNotes + dirtyReminders + dirtyLinks,
    );
  }

  Stream<LocalSyncStatus> watch() {
    final controller = StreamController<LocalSyncStatus>();
    final subscriptions = <StreamSubscription>[];

    Future<void> emit() async {
      if (controller.isClosed) return;

      final status = await load();

      if (!controller.isClosed) {
        controller.add(status);
      }
    }

    controller.onListen = () {
      subscriptions.addAll([
        db.select(db.notesTable).watch().listen((_) => emit()),
        db.select(db.remindersTable).watch().listen((_) => emit()),
        db.select(db.noteLinksTable).watch().listen((_) => emit()),
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
}
