import 'package:drift/drift.dart';
import 'package:front/core/attachments/models/attachment_sync.dart';

import 'package:front/core/db/database.dart';
import 'package:front/core/db/database_provider.dart';

class NoteAttachmentsLocalService {
  final AppDatabase db;

  NoteAttachmentsLocalService({
    AppDatabase? db,
  }) : db = db ?? DatabaseProvider.instance;

  Future<List<NoteAttachmentsTableData>> getDirtyAttachments() {
    return (db.select(db.noteAttachmentsTable)
          ..where((tbl) => tbl.dirty.equals(true)))
        .get();
  }

  Future<List<NoteAttachmentsTableData>> getMissingLocalFiles() {
    return (db.select(db.noteAttachmentsTable)
          ..where((tbl) =>
              tbl.deleted.equals(false) &
              tbl.localPath.isNull() &
              tbl.remoteKey.isNotNull()))
        .get();
  }

  Future<void> upsertLocalAttachment({
    required String id,
    required String noteId,
    required String type,
    required String localPath,
    required String? mimeType,
    required String? fileName,
    required int? sizeBytes,
    required int? durationMs,
    required int? width,
    required int? height,
  }) async {
    final now = DateTime.now().toUtc();

    await db.into(db.noteAttachmentsTable).insertOnConflictUpdate(
          NoteAttachmentsTableCompanion.insert(
            id: id,
            noteId: noteId,
            type: type,
            localPath: Value(localPath),
            mimeType: Value(mimeType),
            fileName: Value(fileName),
            sizeBytes: Value(sizeBytes),
            durationMs: Value(durationMs),
            width: Value(width),
            height: Value(height),
            deleted: const Value(false),
            dirty: const Value(true),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> markUploaded({
    required String id,
    required String? remoteUrl,
    required String? remoteKey,
    required DateTime? serverUpdatedAt,
  }) async {
    await (db.update(db.noteAttachmentsTable)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      NoteAttachmentsTableCompanion(
        remoteUrl: Value(remoteUrl),
        remoteKey: Value(remoteKey),
        serverUpdatedAt: Value(serverUpdatedAt),
        dirty: const Value(false),
      ),
    );
  }

  Future<void> markDeletedSynced(String id) async {
    await (db.update(db.noteAttachmentsTable)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      const NoteAttachmentsTableCompanion(
        dirty: Value(false),
      ),
    );
  }

  Future<void> markLocalPath({
    required String id,
    required String localPath,
  }) async {
    await (db.update(db.noteAttachmentsTable)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      NoteAttachmentsTableCompanion(
        localPath: Value(localPath),
        dirty: const Value(false),
      ),
    );
  }

  Future<void> applyPulledAttachments(
    List<AttachmentSyncItem> attachments,
  ) async {
    if (attachments.isEmpty) return;

    final companions = attachments.map((item) {
      return NoteAttachmentsTableCompanion.insert(
        id: item.id,
        noteId: item.noteId,
        type: item.type,
        localPath: const Value.absent(),
        remoteUrl: Value(item.remoteUrl),
        remoteKey: Value(item.remoteKey),
        mimeType: Value(item.mimeType),
        fileName: Value(item.fileName),
        sizeBytes: Value(item.sizeBytes),
        durationMs: Value(item.durationMs),
        width: Value(item.width),
        height: Value(item.height),
        deleted: Value(item.deleted),
        deletedAt: Value(item.deletedAt),
        dirty: const Value(false),
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
        serverUpdatedAt: Value(item.serverUpdatedAt),
      );
    }).toList();

    await db.batch((batch) {
      batch.insertAllOnConflictUpdate(
        db.noteAttachmentsTable,
        companions,
      );
    });
  }

  Future<void> markDeleted({
    required String id,
  }) async {
    final now = DateTime.now().toUtc();

    await (db.update(db.noteAttachmentsTable)
          ..where((tbl) => tbl.id.equals(id)))
        .write(
      NoteAttachmentsTableCompanion(
        deleted: const Value(true),
        deletedAt: Value(now),
        dirty: const Value(true),
        updatedAt: Value(now),
      ),
    );
  }
}