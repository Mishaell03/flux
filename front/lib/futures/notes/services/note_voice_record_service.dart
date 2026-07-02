import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:front/core/attachments/services/note_attachment_create_service.dart';
import 'package:record/record.dart';
import 'package:uuid/uuid.dart';

class NoteVoiceRecordService {
  static const int _sampleRate = 44100;
  static const int _numChannels = 1;
  static const int _bitsPerSample = 16;

  final AudioRecorder _recorder = AudioRecorder();
  final NoteAttachmentCreateService _createService;

  StreamSubscription<Uint8List>? _sub;
  final BytesBuilder _pcmBuffer = BytesBuilder(copy: false);

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

    _pcmBuffer.clear();
    _startedAt = DateTime.now();

    // Пишем не напрямую в файл (start(path:)), а потоком сырых PCM-сэмплов
    // (startStream). На macOS файловый режим record идёт через
    // AVCaptureSession + AVCaptureAudioFileOutput — этот нативный путь
    // оказался нестабилен: падает и на WAV (AudioFileCreateWithURL,
    // OSStatus 'wht?'), и на AAC (не может собрать внутренний audio-graph
    // ещё до записи). Потоковый режим на macOS реализован через
    // AVAudioEngine + tap — намного более простой и надёжный путь,
    // который к тому же одинаково доступен на всех платформах.
    // WAV-файл собираем сами из полученных PCM-байтов — см. stop().
    final stream = await _recorder.startStream(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: _sampleRate,
        numChannels: _numChannels,
      ),
    );

    _sub = stream.listen(
      _pcmBuffer.add,
      onError: (_) {},
    );

    _isRecording = true;
  }

  Future<NoteAttachmentCreateResult?> stop({
    required String noteId,
  }) async {
    if (!_isRecording) return null;

    await _recorder.stop();
    await _sub?.cancel();
    _sub = null;
    _isRecording = false;

    final pcmBytes = _pcmBuffer.takeBytes();

    if (pcmBytes.isEmpty) {
      _startedAt = null;
      return null;
    }

    final wavBytes = _wrapPcmAsWav(pcmBytes);

    final durationMs = _startedAt == null
        ? null
        : DateTime.now().difference(_startedAt!).inMilliseconds;

    final result = await _createService.createAudio(
      noteId: noteId,
      bytes: wavBytes,
      extension: 'wav',
      mimeType: 'audio/wav',
      fileName: '${const Uuid().v4()}.wav',
      durationMs: durationMs,
    );

    _startedAt = null;

    return result;
  }

  Future<void> cancel() async {
    if (_isRecording) {
      await _recorder.stop();
    }

    await _sub?.cancel();
    _sub = null;
    _isRecording = false;
    _pcmBuffer.clear();
    _startedAt = null;
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    await _recorder.dispose();
  }

  /// Оборачивает сырые 16-bit PCM моно-сэмплы в стандартный 44-байтовый
  /// заголовок RIFF/WAVE, получая обычный проигрываемый .wav файл —
  /// без единого обращения к нативному аудио-писателю ОС.
  Uint8List _wrapPcmAsWav(Uint8List pcmData) {
    const int bytesPerSample = _bitsPerSample ~/ 8;
    final int byteRate = _sampleRate * _numChannels * bytesPerSample;
    final int blockAlign = _numChannels * bytesPerSample;
    final int dataSize = pcmData.length;

    final header = BytesBuilder();
    header.add(ascii.encode('RIFF'));
    header.add(_uint32le(36 + dataSize));
    header.add(ascii.encode('WAVE'));
    header.add(ascii.encode('fmt '));
    header.add(_uint32le(16));
    header.add(_uint16le(1));
    header.add(_uint16le(_numChannels));
    header.add(_uint32le(_sampleRate));
    header.add(_uint32le(byteRate));
    header.add(_uint16le(blockAlign));
    header.add(_uint16le(_bitsPerSample));
    header.add(ascii.encode('data'));
    header.add(_uint32le(dataSize));

    return (BytesBuilder()
      ..add(header.toBytes())
      ..add(pcmData))
        .toBytes();
  }

  Uint8List _uint16le(int value) {
    final bytes = Uint8List(2);
    bytes.buffer.asByteData().setUint16(0, value, Endian.little);
    return bytes;
  }

  Uint8List _uint32le(int value) {
    final bytes = Uint8List(4);
    bytes.buffer.asByteData().setUint32(0, value, Endian.little);
    return bytes;
  }
}