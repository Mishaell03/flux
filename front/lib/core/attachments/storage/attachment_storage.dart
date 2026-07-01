import 'package:front/core/attachments/storage/attachment_storage_contract.dart';
import 'package:front/core/db/database.dart';
import 'attachment_storage_stub.dart'
    if (dart.library.io) 'attachment_storage_io.dart'
    if (dart.library.html) 'attachment_storage_web.dart' as impl;

export 'attachment_storage_contract.dart';

AttachmentStorage createAttachmentStorage({
  AppDatabase? db,
}) {
  return impl.createAttachmentStorage(db: db);
}