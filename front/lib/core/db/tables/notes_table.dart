import 'package:drift/drift.dart';

class NotesTable extends Table {
  TextColumn get id => text()();

  TextColumn get title => text().nullable()();

  TextColumn get content => text().nullable()();

  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  IntColumn get version => integer().withDefault(const Constant(0))();

  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
