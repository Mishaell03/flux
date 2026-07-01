import 'dart:typed_data';

import 'package:front/core/api/api_config.dart';
import 'package:front/core/api/request/delete.dart';
import 'package:front/core/api/request/get.dart';
import 'package:front/core/api/request/get_bytes.dart';
import 'package:front/core/api/request/post.dart';
import 'package:front/core/attachments/models/attachment_sync.dart';

class NoteAttachmentsApiService {
  const NoteAttachmentsApiService();

  Future<List<AttachmentSyncItem>> getAll({
    required String token,
  }) async {
    final response = await GetService.request(
      url: ApiConfig.noteAttachments,
      token: token,
    );

    final raw = response['attachments'];

    if (raw is! List) return [];

    return raw
        .whereType<Map>()
        .map(
          (item) => AttachmentSyncItem.fromJson(
            Map<String, dynamic>.from(item),
          ),
        )
        .toList();
  }

  Future<AttachmentUploadResult> upload({
    required String token,
    required String id,
    required String noteId,
    required String type,
    required Uint8List bytes,
    required String? mimeType,
    required String? fileName,
    required int? durationMs,
    required int? width,
    required int? height,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) async {
    final fields = <String, String>{
      'id': id,
      'note_id': noteId,
      'type': type,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
      if (mimeType != null && mimeType.trim().isNotEmpty)
        'mime_type': mimeType.trim(),
      if (fileName != null && fileName.trim().isNotEmpty)
        'file_name': fileName.trim(),
      if (durationMs != null) 'duration_ms': '$durationMs',
      if (width != null) 'width': '$width',
      if (height != null) 'height': '$height',
    };

    final response = await PostMultipartService.request(
      url: ApiConfig.noteAttachmentsUpload,
      token: token,
      fields: fields,
      fileBytes: bytes,
      fileField: 'file',
      fileName: fileName?.trim().isNotEmpty == true ? fileName!.trim() : id,
      error: 'ATTACHMENT_UPLOAD_FAILED',
    );

    return AttachmentUploadResult.fromJson(
      Map<String, dynamic>.from(response),
    );
  }

  Future<void> delete({
    required String token,
    required String id,
  }) async {
    await DeleteService.request(
      url: '${ApiConfig.noteAttachments}/$id',
      token: token,
      error: 'ATTACHMENT_DELETE_FAILED',
    );
  }

  Future<Uint8List> downloadBytes({
    required String token,
    required String id,
  }) {
    return GetBytesService.request(
      url: '${ApiConfig.noteAttachments}/$id/file',
      token: token,
      error: 'ATTACHMENT_DOWNLOAD_FAILED',
    );
  }
}