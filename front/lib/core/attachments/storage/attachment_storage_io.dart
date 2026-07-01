import 'dart:io';
import 'dart:typed_data';
import 'package:front/core/attachments/storage/attachment_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:front/core/db/database.dart';

AttachmentStorage createAttachmentStorage({
  AppDatabase? db,
}) {
  return IoAttachmentStorage();
}

class IoAttachmentStorage implements AttachmentStorage {
  @override
  Future<StoredAttachmentFile> saveBytes({
    required String noteId,
    required String attachmentId,
    required AttachmentFileType type,
    required Uint8List bytes,
    required String extension,
  }) async {
    final supportDir = await getApplicationSupportDirectory();

    final attachmentsDir = Directory(
      p.join(
        supportDir.path,
        'flux',
        'attachments',
        noteId,
      ),
    );

    if (!await attachmentsDir.exists()) {
      await attachmentsDir.create(recursive: true);
    }

    final safeExtension = extension.replaceAll('.', '').trim();
    final filePath = p.join(
      attachmentsDir.path,
      '$attachmentId.$safeExtension',
    );

    final file = File(filePath);
    await file.writeAsBytes(bytes, flush: true);

    return StoredAttachmentFile(
      localRef: file.path,
      sizeBytes: bytes.length,
    );
  }

  @override
  Future<Uint8List> readBytes(String localRef) async {
    final file = File(localRef);

    if (!await file.exists()) {
      throw StateError('Attachment file not found: $localRef');
    }

    return file.readAsBytes();
  }

  @override
  Future<void> delete(String localRef) async {
    final file = File(localRef);

    if (await file.exists()) {
      await file.delete();
    }
  }
}