import 'package:front/core/attachments/services/note_attachment_create_service.dart';

class NoteVoiceRecordService {
  bool get isRecording => false;

  Future<void> start() {
    throw UnsupportedError('Voice recording is not supported on this platform');
  }

  Future<NoteAttachmentCreateResult?> stop({
    required String noteId,
  }) {
    throw UnsupportedError('Voice recording is not supported on this platform');
  }

  Future<void> cancel() async {}

  Future<void> dispose() async {}
}