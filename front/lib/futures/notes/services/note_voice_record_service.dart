import 'dart:io';

import 'package:front/core/attachments/services/note_attachment_create_service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class NoteVoiceRecordService {
  final AudioRecorder _recorder = AudioRecorder();
  final NoteAttachmentCreateService _createService;

  String? _tempPath;
  DateTime? _startedAt;
  bool _isRecording = false;

  NoteVoiceRecordService({
    NoteAttachmentCreateService? createService,
  }) : _createService = createService ?? NoteAttachmentCreateService();

  bool get isRecording => _isRecording;

  Future<void> start() async {
    if (_isRecording) return;

    final hasPermission = await _recorder.hasPermission();

    if (!hasPermission) {
      throw StateError('MICROPHONE_PERMISSION_DENIED');
    }

    final dir = await getTemporaryDirectory();
    final tempName = 'flux_voice_${const Uuid().v4()}.wav';

    _tempPath = p.join(dir.path, tempName);
    _startedAt = DateTime.now();

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 44100,
      ),
      path: _tempPath!,
    );

    _isRecording = true;
  }

  Future<NoteAttachmentCreateResult?> stop({
    required String noteId,
  }) async {
    if (!_isRecording) return null;

    final recordedPath = await _recorder.stop();
    _isRecording = false;

    final path = recordedPath ?? _tempPath;

    if (path == null || path.isEmpty) {
      return null;
    }

    final file = File(path);

    if (!await file.exists()) {
      return null;
    }

    final bytes = await file.readAsBytes();

    if (bytes.isEmpty) {
      return null;
    }

    final durationMs = _startedAt == null
        ? null
        : DateTime.now().difference(_startedAt!).inMilliseconds;

    final result = await _createService.createAudio(
      noteId: noteId,
      bytes: bytes,
      extension: 'wav',
      mimeType: 'audio/wav',
      fileName: '${const Uuid().v4()}.wav',
      durationMs: durationMs,
    );

    await file.delete().catchError((_) {});

    _tempPath = null;
    _startedAt = null;

    return result;
  }

  Future<void> cancel() async {
    if (_isRecording) {
      await _recorder.cancel();
    }

    _isRecording = false;

    final path = _tempPath;

    if (path != null) {
      final file = File(path);

      if (await file.exists()) {
        await file.delete().catchError((_) {});
      }
    }

    _tempPath = null;
    _startedAt = null;
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }
}