class AttachmentSyncItem {
  final String id;
  final String noteId;
  final String type;
  final String? remoteUrl;
  final String? remoteKey;
  final String? mimeType;
  final String? fileName;
  final int? sizeBytes;
  final int? durationMs;
  final int? width;
  final int? height;
  final bool deleted;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? serverUpdatedAt;

  const AttachmentSyncItem({
    required this.id,
    required this.noteId,
    required this.type,
    required this.remoteUrl,
    required this.remoteKey,
    required this.mimeType,
    required this.fileName,
    required this.sizeBytes,
    required this.durationMs,
    required this.width,
    required this.height,
    required this.deleted,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.serverUpdatedAt,
  });

  factory AttachmentSyncItem.fromJson(Map<String, dynamic> json) {
    return AttachmentSyncItem(
      id: json['id'].toString(),
      noteId: json['note_id'].toString(),
      type: json['type'].toString(),
      remoteUrl: json['remote_url']?.toString(),
      remoteKey: json['remote_key']?.toString(),
      mimeType: json['mime_type']?.toString(),
      fileName: json['file_name']?.toString(),
      sizeBytes: (json['size_bytes'] as num?)?.toInt(),
      durationMs: (json['duration_ms'] as num?)?.toInt(),
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      deleted: json['deleted'] == true,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'].toString()).toUtc(),
      createdAt: DateTime.parse(json['created_at'].toString()).toUtc(),
      updatedAt: DateTime.parse(json['updated_at'].toString()).toUtc(),
      serverUpdatedAt: json['server_updated_at'] == null
          ? null
          : DateTime.parse(json['server_updated_at'].toString()).toUtc(),
    );
  }
}

class AttachmentUploadResult {
  final String id;
  final String? remoteUrl;
  final String? remoteKey;
  final DateTime? serverUpdatedAt;

  const AttachmentUploadResult({
    required this.id,
    required this.remoteUrl,
    required this.remoteKey,
    required this.serverUpdatedAt,
  });

  factory AttachmentUploadResult.fromJson(Map<String, dynamic> json) {
    return AttachmentUploadResult(
      id: json['id'].toString(),
      remoteUrl: json['remote_url']?.toString(),
      remoteKey: json['remote_key']?.toString(),
      serverUpdatedAt: json['server_updated_at'] == null
          ? null
          : DateTime.parse(json['server_updated_at'].toString()).toUtc(),
    );
  }
}