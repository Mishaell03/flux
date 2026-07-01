import 'dart:typed_data';

import 'package:drift/drift.dart';
import 'package:front/core/attachments/storage/attachment_storage.dart';

import 'package:front/core/db/database.dart';
import 'package:front/core/db/database_provider.dart';

AttachmentStorage createAttachmentStorage({
  AppDatabase? db,
}) {
  return WebAttachmentStorage(
    db: db ?? DatabaseProvider.instance,
  );
}

class WebAttachmentStorage implements AttachmentStorage {
  final AppDatabase db;

  WebAttachmentStorage({
    required this.db,
  });

  @override
  Future<StoredAttachmentFile> saveBytes({
    required String noteId,
    required String attachmentId,
    required AttachmentFileType type,
    required Uint8List bytes,
    required String extension,
  }) async {
    await db.into(db.attachmentBlobsTable).insertOnConflictUpdate(
          AttachmentBlobsTableCompanion.insert(
            id: attachmentId,
            bytes: bytes,
            updatedAt: DateTime.now().toUtc(),
          ),
        );

    return StoredAttachmentFile(
      localRef: 'web://attachment/$attachmentId',
      sizeBytes: bytes.length,
    );
  }

  @override
  Future<Uint8List> readBytes(String localRef) async {
    final attachmentId = _extractAttachmentId(localRef);

    final row = await (db.select(db.attachmentBlobsTable)
          ..where((tbl) => tbl.id.equals(attachmentId)))
        .getSingleOrNull();

    if (row == null) {
      throw StateError('Web attachment blob not found: $attachmentId');
    }

    return row.bytes;
  }

  @override
  Future<void> delete(String localRef) async {
    final attachmentId = _extractAttachmentId(localRef);

    await (db.delete(db.attachmentBlobsTable)
          ..where((tbl) => tbl.id.equals(attachmentId)))
        .go();
  }

  String _extractAttachmentId(String localRef) {
    const prefix = 'web://attachment/';

    if (!localRef.startsWith(prefix)) {
      throw ArgumentError('Invalid web attachment ref: $localRef');
    }

    return localRef.substring(prefix.length);
  }
}