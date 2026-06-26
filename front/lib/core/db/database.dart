import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:front/core/db/tables/notes_table.dart';
import 'package:front/core/db/tables/reminders_table.dart';
import 'package:front/core/db/tables/note_links_table.dart';

part "database.g.dart";

@DriftDatabase(
  tables: [
    NotesTable,
    RemindersTable,
    NoteLinksTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase()
      : super(
          driftDatabase(
            name: 'flux_db',
            web: DriftWebOptions(
              sqlite3Wasm: Uri.parse('sqlite3.wasm'),
              driftWorker: Uri.parse('drift_worker.js'),
            ),
          ),
        );

  @override
  int get schemaVersion => 1;
}
