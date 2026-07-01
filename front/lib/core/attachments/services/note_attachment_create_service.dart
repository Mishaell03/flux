import 'dart:typed_data';
import 'package:front/core/attachments/services/note_attachments_local_service.dart';
import 'package:front/core/attachments/storage/attachment_storage.dart';
import 'package:uuid/uuid.dart';

class NoteAttachmentCreateResult {
  final String id;
  final String marker;
  final String localPath;

  const NoteAttachmentCreateResult({
    required this.id,
    required this.marker,
    required this.localPath,
  });
}

class NoteAttachmentCreateService {
  final NoteAttachmentsLocalService local;
  final AttachmentStorage storage;

  NoteAttachmentCreateService({
    NoteAttachmentsLocalService? local,
    AttachmentStorage? storage,
  })  : local = local ?? NoteAttachmentsLocalService(),
        storage = storage ?? createAttachmentStorage();

  Future<NoteAttachmentCreateResult> createImage({
    required String noteId,
    required Uint8List bytes,
    String extension = 'jpg',
    String? mimeType = 'image/jpeg',
    String? fileName,
    int? width,
    int? height,
  }) {
    return _create(
      noteId: noteId,
      type: AttachmentFileType.image,
      bytes: bytes,
      extension: extension,
      mimeType: mimeType,
      fileName: fileName,
      durationMs: null,
      width: width,
      height: height,
    );
  }

  Future<NoteAttachmentCreateResult> createAudio({
    required String noteId,
    required Uint8List bytes,
    String extension = 'm4a',
    String? mimeType = 'audio/mp4',
    String? fileName,
    int? durationMs,
  }) {
    return _create(
      noteId: noteId,
      type: AttachmentFileType.audio,
      bytes: bytes,
      extension: extension,
      mimeType: mimeType,
      fileName: fileName,
      durationMs: durationMs,
      width: null,
      height: null,
    );
  }

  Future<NoteAttachmentCreateResult> _create({
    required String noteId,
    required AttachmentFileType type,
    required Uint8List bytes,
    required String extension,
    required String? mimeType,
    required String? fileName,
    required int? durationMs,
    required int? width,
    required int? height,
  }) async {
    final id = const Uuid().v4();

    final stored = await storage.saveBytes(
      noteId: noteId,
      attachmentId: id,
      type: type,
      bytes: bytes,
      extension: extension,
    );

    final typeValue = attachmentFileTypeToString(type);

    await local.upsertLocalAttachment(
      id: id,
      noteId: noteId,
      type: typeValue,
      localPath: stored.localRef,
      mimeType: mimeType,
      fileName: fileName ?? '$id.$extension',
      sizeBytes: stored.sizeBytes,
      durationMs: durationMs,
      width: width,
      height: height,
    );

    return NoteAttachmentCreateResult(
      id: id,
      marker: '{{attachment:$typeValue|$id}}',
      localPath: stored.localRef,
    );
  }
}
