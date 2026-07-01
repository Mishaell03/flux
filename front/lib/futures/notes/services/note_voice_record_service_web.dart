import 'dart:html' as html;
import 'dart:typed_data';

import 'package:front/core/attachments/services/note_attachment_create_service.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class NoteVoiceRecordService {
  final AudioRecorder _recorder = AudioRecorder();
  final NoteAttachmentCreateService _createService;

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

    _startedAt = DateTime.now();

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.wav,
        sampleRate: 44100,
      ),
      path: 'flux_voice_${const Uuid().v4()}.wav',
    );

    _isRecording = true;
  }

  Future<NoteAttachmentCreateResult?> stop({
    required String noteId,
  }) async {
    if (!_isRecording) return null;

    final path = await _recorder.stop();
    _isRecording = false;

    if (path == null || path.isEmpty) {
      return null;
    }

    final bytes = await _readBlobBytes(path);

    if (bytes.isEmpty) {
      return null;
    }

    final durationMs = _startedAt == null
        ? null
        : DateTime.now().difference(_startedAt!).inMilliseconds;

    _startedAt = null;

    return _createService.createAudio(
      noteId: noteId,
      bytes: bytes,
      extension: 'wav',
      mimeType: 'audio/wav',
      fileName: '${const Uuid().v4()}.wav',
      durationMs: durationMs,
    );
  }

  Future<void> cancel() async {
    if (_isRecording) {
      await _recorder.cancel();
    }

    _isRecording = false;
    _startedAt = null;
  }

  Future<void> dispose() async {
    await _recorder.dispose();
  }

  Future<Uint8List> _readBlobBytes(String url) async {
    final request = await html.HttpRequest.request(
      url,
      responseType: 'arraybuffer',
    );

    final response = request.response;

    if (response is ByteBuffer) {
      return Uint8List.view(response);
    }

    return Uint8List(0);
  }
}