import 'package:front/core/attachments/storage/attachment_storage.dart';
import 'package:front/core/db/database.dart';

AttachmentStorage createAttachmentStorage({
  AppDatabase? db,
}) {
  throw UnsupportedError('Attachment storage is not supported on this platform');
}