import 'package:front/core/attachments/services/note_attachments_api_service.dart';
import 'package:front/core/attachments/services/note_attachments_local_service.dart';
import 'package:front/core/attachments/storage/attachment_storage.dart';

class NoteAttachmentsSyncService {
  final NoteAttachmentsApiService api;
  final NoteAttachmentsLocalService local;
  final AttachmentStorage storage;

  bool _isSyncing = false;

  NoteAttachmentsSyncService({
    NoteAttachmentsApiService? api,
    NoteAttachmentsLocalService? local,
    AttachmentStorage? storage,
  })  : api = api ?? const NoteAttachmentsApiService(),
        local = local ?? NoteAttachmentsLocalService(),
        storage = storage ?? createAttachmentStorage();

  Future<void> sync({
    required String token,
  }) async {
    if (_isSyncing) return;

    _isSyncing = true;

    try {
      await _pushDirtyAttachments(token: token);
      await _pullRemoteAttachments(token: token);
      await _downloadMissingFiles(token: token);
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _pushDirtyAttachments({
    required String token,
  }) async {
    final dirtyAttachments = await local.getDirtyAttachments();

    for (final attachment in dirtyAttachments) {
      if (attachment.deleted) {
        await api.delete(
          token: token,
          id: attachment.id,
        );

        await local.markDeletedSynced(attachment.id);
        continue;
      }

      final localPath = attachment.localPath;

      if (localPath == null || localPath.isEmpty) {
        continue;
      }

      final bytes = await storage.readBytes(localPath);

      final result = await api.upload(
        token: token,
        id: attachment.id,
        noteId: attachment.noteId,
        type: attachment.type,
        bytes: bytes,
        mimeType: attachment.mimeType,
        fileName: attachment.fileName,
        durationMs: attachment.durationMs,
        width: attachment.width,
        height: attachment.height,
        createdAt: attachment.createdAt,
        updatedAt: attachment.updatedAt,
      );

      await local.markUploaded(
        id: attachment.id,
        remoteUrl: result.remoteUrl,
        remoteKey: result.remoteKey,
        serverUpdatedAt: result.serverUpdatedAt,
      );
    }
  }

  Future<void> _pullRemoteAttachments({
    required String token,
  }) async {
    final attachments = await api.getAll(token: token);
    await local.applyPulledAttachments(attachments);
  }

  Future<void> _downloadMissingFiles({
    required String token,
  }) async {
    final missingFiles = await local.getMissingLocalFiles();

    for (final attachment in missingFiles) {
      if (attachment.deleted) continue;

      final bytes = await api.downloadBytes(
        token: token,
        id: attachment.id,
      );

      final extension = _extensionFor(
        type: attachment.type,
        mimeType: attachment.mimeType,
        fileName: attachment.fileName,
      );

      final stored = await storage.saveBytes(
        noteId: attachment.noteId,
        attachmentId: attachment.id,
        type: attachment.type == 'audio'
            ? AttachmentFileType.audio
            : AttachmentFileType.image,
        bytes: bytes,
        extension: extension,
      );

      await local.markLocalPath(
        id: attachment.id,
        localPath: stored.localRef,
      );
    }
  }

  String _extensionFor({
    required String type,
    required String? mimeType,
    required String? fileName,
  }) {
    final fileExt = _extensionFromFileName(fileName);

    if (fileExt != null) return fileExt;

    switch (mimeType) {
      case 'image/png':
        return 'png';
      case 'image/webp':
        return 'webp';
      case 'image/heic':
        return 'heic';
      case 'audio/mpeg':
        return 'mp3';
      case 'audio/mp4':
      case 'audio/aac':
        return 'm4a';
      case 'audio/wav':
      case 'audio/x-wav':
        return 'wav';
      case 'image/jpeg':
      default:
        return type == 'audio' ? 'm4a' : 'jpg';
    }
  }

  String? _extensionFromFileName(String? fileName) {
    if (fileName == null || fileName.trim().isEmpty) {
      return null;
    }

    final parts = fileName.split('.');

    if (parts.length < 2) return null;

    final ext = parts.last.trim().toLowerCase();

    if (ext.isEmpty || ext.length > 8) return null;

    return ext;
  }
}
