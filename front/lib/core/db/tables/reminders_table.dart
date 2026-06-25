import 'package:drift/drift.dart';

class RemindersTable extends Table {
  TextColumn get id => text()();

  TextColumn get noteId => text().nullable()();

  DateTimeColumn get remindAt => dateTime()();

  BoolColumn get isDone => boolean().withDefault(const Constant(false))();

  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  TextColumn get repeatRule => text().nullable()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get serverUpdatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
