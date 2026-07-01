import 'dart:typed_data';
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

  Future<NoteImagePickResult?> pickFromGallery({
    required String noteId,
  }) {
    return _pickAndSave(
      noteId: noteId,
      source: NoteImagePickSource.gallery,
    );
  }

  Future<NoteImagePickResult?> takePhoto({
    required String noteId,
  }) {
    return _pickAndSave(
      noteId: noteId,
      source: NoteImagePickSource.camera,
    );
  }

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

    if (image == null) {
      return null;
    }

    final bytes = await image.readAsBytes();

    if (bytes.isEmpty) {
      return null;
    }

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

      if (ext.isNotEmpty && ext.length <= 8) {
        return ext;
      }
    }

    return 'jpg';
  }

  Future<NoteImagePickResult?> retrieveLostImage({
    required String noteId,
  }) async {
    final response = await _picker.retrieveLostData();

    if (response.isEmpty) {
      return null;
    }

    final files = response.files;

    if (files == null || files.isEmpty) {
      return null;
    }

    final image = files.first;
    final bytes = await image.readAsBytes();

    if (bytes.isEmpty) {
      return null;
    }

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