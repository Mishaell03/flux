import 'dart:typed_data';
import 'package:front/core/db/database.dart';

enum AttachmentFileType {
  image,
  audio,
}

class StoredAttachmentFile {
  final String localRef;
  final int sizeBytes;

  const StoredAttachmentFile({
    required this.localRef,
    required this.sizeBytes,
  });
}

abstract class AttachmentStorage {
  Future<StoredAttachmentFile> saveBytes({
    required String noteId,
    required String attachmentId,
    required AttachmentFileType type,
    required Uint8List bytes,
    required String extension,
  });

  Future<Uint8List> readBytes(String localRef);

  Future<void> delete(String localRef);
}

AttachmentFileType attachmentFileTypeFromString(String value) {
  switch (value) {
    case 'audio':
      return AttachmentFileType.audio;
    case 'image':
    default:
      return AttachmentFileType.image;
  }
}

String attachmentFileTypeToString(AttachmentFileType type) {
  switch (type) {
    case AttachmentFileType.image:
      return 'image';
    case AttachmentFileType.audio:
      return 'audio';
  }
}

typedef AttachmentStorageFactory = AttachmentStorage Function({
  AppDatabase? db,
});