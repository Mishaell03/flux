import 'package:drift/drift.dart';

class RemindersTable extends Table {
  TextColumn get id => text()();
  TextColumn get noteId => text().nullable()();
  DateTimeColumn get remindAt => dateTime()();
  BoolColumn get isDone => boolean().withDefault(const Constant(false))();
  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  IntColumn get version => integer().withDefault(const Constant(0))();
  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}