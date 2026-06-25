import 'package:drift/drift.dart';

class NotesTable extends Table {
  TextColumn get id => text()();

  TextColumn get title => text().nullable()();

  TextColumn get content => text().nullable()();

  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get serverUpdatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
