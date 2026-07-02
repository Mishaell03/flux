import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front/core/attachments/services/note_attachment_create_service.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/markdown/app_markdown_settings.dart';
import 'package:front/futures/notes/services/note_attachment_opener.dart';
import 'package:front/futures/notes/services/note_image_picker_service.dart';
import 'package:front/futures/notes/widgets/note_voice_record_sheet.dart';
import 'package:front/l10n/app_localizations.dart';

/// Единая точка для логики вложений (фото/аудио).
/// Убирает дублирование между NoteEditorPage и ReminderEditorPage.
///
/// [beforeAttachment] — вызывается перед каждой операцией с вложением
///   (например, _ensureNoteSaved в ReminderEditorPage).
/// [afterAttachment]  — вызывается после успешной вставки маркера.
/// [onContentChanged] — вызывается после обновления contentController,
///   чтобы страница могла вызвать setState и перерисовать редактор.
class NoteAttachmentFlow {
  final String noteId;
  final TextEditingController contentController;
  final Future<void> Function()? beforeAttachment;
  final Future<void> Function()? afterAttachment;
  final VoidCallback? onContentChanged;

  final NoteImagePickerService _imagePicker;
  final NoteAttachmentOpener _opener;

  /// На каких платформах доступна камера через image_picker.
  /// Desktop (Windows/macOS/Linux) не поддерживается нативно.
  static bool get _cameraSupported =>
      !kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS);

  /// Запись аудио недоступна на Web в пакете record <5.x без MediaRecorder.
  /// record ≥5 поддерживает web, поэтому разрешаем везде кроме явно неизвестных.
  static bool get _audioSupported => true;

  NoteAttachmentFlow({
    required this.noteId,
    required this.contentController,
    this.beforeAttachment,
    this.afterAttachment,
    this.onContentChanged,
    NoteImagePickerService? imagePicker,
    NoteAttachmentOpener? opener,
  })  : _imagePicker = imagePicker ?? NoteImagePickerService(),
        _opener = opener ?? NoteAttachmentOpener();

  Future<void> showImageSourceSheet(BuildContext context) async {
    final colors = context.colors;
    final t = AppLocalizations.of(context)!;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Container(
              decoration: BoxDecoration(
                color: colors.bg,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: colors.border, width: 1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 38,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colors.gray.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ListTile(
                    leading: const Icon(Icons.photo_library_rounded),
                    title: Text(t.chooseGallery),
                    onTap: () {
                      Navigator.pop(ctx);
                      _addImageFromGallery(context);
                    },
                  ),
                  if (_cameraSupported) ...[
                    Divider(height: 1, color: colors.border),
                    ListTile(
                      leading: const Icon(Icons.photo_camera_rounded),
                      title: Text(t.takePhoto),
                      onTap: () {
                        Navigator.pop(ctx);
                        _addImageFromCamera(context);
                      },
                    ),
                  ],
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Запускает запись голосового сообщения.
  /// Если платформа не поддерживает запись — показывает snackbar
  Future<void> recordVoiceMessage(BuildContext context) async {
    if (!_audioSupported) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Запись аудио недоступна на этой платформе'),
          ),
        );
      }
      return;
    }

    await beforeAttachment?.call();

    if (!context.mounted) return;

    final result = await showModalBottomSheet<NoteAttachmentCreateResult?>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (ctx) => NoteVoiceRecordSheet(noteId: noteId),
    );

    if (result == null) return;

    _insertMarker(result.marker);
    await afterAttachment?.call();
  }

  Future<void> openAttachment(
      BuildContext context,
      MarkdownAttachmentData attachment,
      ) async {
    await _opener.open(context, attachment);
  }

  /// Приватные методы

  Future<void> _addImageFromGallery(BuildContext context) async {
    await beforeAttachment?.call();

    final result = await _imagePicker.pickFromGallery(noteId: noteId);

    if (result == null) return;

    _insertMarker(result.marker);
    await afterAttachment?.call();
  }

  Future<void> _addImageFromCamera(BuildContext context) async {
    await beforeAttachment?.call();

    final result = await _imagePicker.takePhoto(noteId: noteId);

    if (result == null) return;

    _insertMarker(result.marker);
    await afterAttachment?.call();
  }

  void _insertMarker(String marker) {
    final current = contentController.text.trimRight();
    final next = current.isEmpty ? marker : '$current\n\n$marker';

    contentController.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: next.length),
    );

    onContentChanged?.call();
  }
}