import 'package:drift/drift.dart';

class NoteAttachmentsTable extends Table {
  TextColumn get id => text()();

  TextColumn get noteId => text()();

  TextColumn get type => text()(); // image | audio

  TextColumn get localPath => text().nullable()();

  TextColumn get remoteUrl => text().nullable()();

  TextColumn get remoteKey => text().nullable()();

  TextColumn get mimeType => text().nullable()();

  TextColumn get fileName => text().nullable()();

  IntColumn get sizeBytes => integer().nullable()();

  IntColumn get durationMs => integer().nullable()();

  IntColumn get width => integer().nullable()();

  IntColumn get height => integer().nullable()();

  BoolColumn get deleted => boolean().withDefault(const Constant(false))();

  BoolColumn get dirty => boolean().withDefault(const Constant(false))();

  DateTimeColumn get deletedAt => dateTime().nullable()();

  DateTimeColumn get updatedAt => dateTime()();

  DateTimeColumn get createdAt => dateTime()();

  DateTimeColumn get serverUpdatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}