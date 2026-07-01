import 'package:drift/drift.dart';

//для веба
class AttachmentBlobsTable extends Table {
  TextColumn get id => text()();

  BlobColumn get bytes => blob()();

  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
