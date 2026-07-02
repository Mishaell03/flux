import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:front/core/attachments/services/note_attachment_create_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

enum NoteImagePickSource {
  gallery,
  camera,
}

class NoteImagePickResult {
  final String id;
  final String marker;
  final String localPath;
  final String? fileName;
  final String? mimeType;
  final int sizeBytes;

  const NoteImagePickResult({
    required this.id,
    required this.marker,
    required this.localPath,
    required this.fileName,
    required this.mimeType,
    required this.sizeBytes,
  });
}

class NoteImagePickerService {
  final ImagePicker _picker;
  final NoteAttachmentCreateService _createService;

  NoteImagePickerService({
    ImagePicker? picker,
    NoteAttachmentCreateService? createService,
  })  : _picker = picker ?? ImagePicker(),
        _createService = createService ?? NoteAttachmentCreateService();

  // ─── Поддержка платформ ───────────────────────────────────────────────────

  /// image_picker поддерживает галерею на Android, iOS и Web.
  /// На macOS/Windows/Linux — поддержка ограничена или отсутствует;
  /// gallery через image_picker на macOS работает начиная с image_picker_macos ^0.2,
  /// но на Windows нативного плагина нет — используем graceful fallback (null).
  static bool get gallerySupported {
    if (kIsWeb) return true;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return true;
      default:
        return false;
    }
  }

  /// Камера через image_picker доступна только на Android и iOS.
  static bool get cameraSupported {
    if (kIsWeb) return false; // web камера — через camera package, не image_picker
    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  // ─── Публичный API ────────────────────────────────────────────────────────

  /// Возвращает null, если платформа не поддерживается или пользователь отменил.
  Future<NoteImagePickResult?> pickFromGallery({
    required String noteId,
  }) {
    if (!gallerySupported) return Future.value(null);
    return _pickAndSave(noteId: noteId, source: NoteImagePickSource.gallery);
  }

  /// Возвращает null, если платформа не поддерживает камеру или пользователь отменил.
  Future<NoteImagePickResult?> takePhoto({
    required String noteId,
  }) {
    if (!cameraSupported) return Future.value(null);
    return _pickAndSave(noteId: noteId, source: NoteImagePickSource.camera);
  }

  // ─── Приватные методы ─────────────────────────────────────────────────────

  Future<NoteImagePickResult?> _pickAndSave({
    required String noteId,
    required NoteImagePickSource source,
  }) async {
    final image = await _picker.pickImage(
      source: source == NoteImagePickSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      imageQuality: 85,
      maxWidth: 2200,
    );

    if (image == null) return null;

    final bytes = await image.readAsBytes();

    if (bytes.isEmpty) return null;

    final fileName = image.name.trim().isEmpty ? null : image.name.trim();

    final mimeType = _detectMimeType(
      bytes: bytes,
      fileName: fileName,
      fallback: image.mimeType,
    );

    final extension = _extensionFromMimeOrName(
      mimeType: mimeType,
      fileName: fileName,
    );

    final created = await _createService.createImage(
      noteId: noteId,
      bytes: Uint8List.fromList(bytes),
      extension: extension,
      mimeType: mimeType,
      fileName: fileName,
    );

    return NoteImagePickResult(
      id: created.id,
      marker: created.marker,
      localPath: created.localPath,
      fileName: fileName,
      mimeType: mimeType,
      sizeBytes: bytes.length,
    );
  }

  String? _detectMimeType({
    required List<int> bytes,
    required String? fileName,
    required String? fallback,
  }) {
    if (fallback != null && fallback.trim().isNotEmpty) {
      return fallback.trim().toLowerCase();
    }

    final byHeader = lookupMimeType(
      fileName ?? '',
      headerBytes: bytes.take(32).toList(),
    );

    if (byHeader != null && byHeader.trim().isNotEmpty) {
      return byHeader.trim().toLowerCase();
    }

    return 'image/jpeg';
  }

  String _extensionFromMimeOrName({
    required String? mimeType,
    required String? fileName,
  }) {
    switch (mimeType) {
      case 'image/png':
        return 'png';
      case 'image/webp':
        return 'webp';
      case 'image/heic':
        return 'heic';
      case 'image/heif':
        return 'heif';
      case 'image/jpeg':
      case 'image/jpg':
        return 'jpg';
    }

    if (fileName != null && fileName.contains('.')) {
      final ext = fileName.split('.').last.trim().toLowerCase();
      if (ext.isNotEmpty && ext.length <= 8) return ext;
    }

    return 'jpg';
  }

  /// Восстанавливает потерянный файл после прерывания (Android-специфично).
  /// На других платформах всегда возвращает null.
  Future<NoteImagePickResult?> retrieveLostImage({
    required String noteId,
  }) async {
    if (defaultTargetPlatform != TargetPlatform.android) return null;

    final response = await _picker.retrieveLostData();

    if (response.isEmpty) return null;

    final files = response.files;
    if (files == null || files.isEmpty) return null;

    final image = files.first;
    final bytes = await image.readAsBytes();

    if (bytes.isEmpty) return null;

    final fileName = image.name.trim().isEmpty ? null : image.name.trim();

    final mimeType = _detectMimeType(
      bytes: bytes,
      fileName: fileName,
      fallback: image.mimeType,
    );

    final extension = _extensionFromMimeOrName(
      mimeType: mimeType,
      fileName: fileName,
    );

    final created = await _createService.createImage(
      noteId: noteId,
      bytes: Uint8List.fromList(bytes),
      extension: extension,
      mimeType: mimeType,
      fileName: fileName,
    );

    return NoteImagePickResult(
      id: created.id,
      marker: created.marker,
      localPath: created.localPath,
      fileName: fileName,
      mimeType: mimeType,
      sizeBytes: bytes.length,
    );
  }
}