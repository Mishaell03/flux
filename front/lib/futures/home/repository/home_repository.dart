import 'dart:async';

import 'package:drift/drift.dart';
import 'package:front/core/db/database_provider.dart';
import 'package:front/futures/home/models/home_dashboard.dart';

class HomeRepository {
  final db = DatabaseProvider.instance;

  Future<HomeDashboardData> getDashboardDataForDate(DateTime selectedDate) async {
    final dayStartLocal = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    final dayEndLocal = dayStartLocal.add(const Duration(days: 1));

    final dayStartUtc = dayStartLocal.toUtc();
    final dayEndUtc = dayEndLocal.toUtc();

    final notes = await (db.select(db.notesTable)
      ..where((tbl) => tbl.deleted.equals(false))
      ..orderBy([
            (tbl) => OrderingTerm(
          expression: tbl.updatedAt,
          mode: OrderingMode.desc,
        ),
      ]))
        .get();

    final selectedDayReminders = await (db.select(db.remindersTable)
      ..where(
            (tbl) =>
        tbl.deleted.equals(false) &
        tbl.isDone.equals(false) &
        tbl.remindAt.isBiggerOrEqualValue(dayStartUtc) &
        tbl.remindAt.isSmallerThanValue(dayEndUtc),
      )
      ..orderBy([
            (tbl) => OrderingTerm(
          expression: tbl.remindAt,
          mode: OrderingMode.asc,
        ),
      ]))
        .get();

    final allActiveReminders = await (db.select(db.remindersTable)
      ..where(
            (tbl) => tbl.deleted.equals(false) & tbl.isDone.equals(false),
      ))
        .get();

    final links = await db.select(db.noteLinksTable).get();

    final notesById = {
      for (final note in notes) note.id: note,
    };

    final reminderDayKeys = allActiveReminders.map((reminder) {
      return _dateKey(reminder.remindAt.toLocal());
    }).toSet();

    return HomeDashboardData(
      notesCount: notes.length,
      remindersCount: allActiveReminders.length,
      linkedNotesCount: links.length,
      reminderDayKeys: reminderDayKeys,
      recentNotes: notes.take(4).map((note) {
        return HomeNotePreview(
          id: note.id,
          title: _safeTitle(note.title),
          content: _safeContent(note.content),
          updatedAt: note.updatedAt,
        );
      }).toList(),
      upcomingReminders: selectedDayReminders.map((reminder) {
        final note = reminder.noteId == null ? null : notesById[reminder.noteId];

        return HomeReminderPreview(
          id: reminder.id,
          title: _safeTitle(note?.title ?? 'Reminder'),
          remindAt: reminder.remindAt,
        );
      }).toList(),
    );
  }

  Stream<HomeDashboardData> watchDashboardDataForDate(DateTime selectedDate) {
    final controller = StreamController<HomeDashboardData>();

    final subscriptions = <StreamSubscription>[];

    Future<void> emit() async {
      if (controller.isClosed) return;

      final data = await getDashboardDataForDate(selectedDate);

      if (!controller.isClosed) {
        controller.add(data);
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

  String _dateKey(DateTime date) {
    final local = date.toLocal();

    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');

    return '$y-$m-$d';
  }
}