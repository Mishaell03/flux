import 'package:drift/drift.dart';

class NoteLinksTable extends Table {
  TextColumn get fromId => text()();

  TextColumn get toId => text()();

  IntColumn get weight => integer().withDefault(const Constant(1))();

  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  DateTimeColumn get updatedAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {fromId, toId};
}
