import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:front/core/attachments/services/note_attachment_create_service.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/markdown/app_markdown_settings.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/core/db/database.dart';
import 'package:front/core/db/database_provider.dart';
import 'package:front/core/widgets/markdown_live_editor.dart';
import 'package:front/futures/notes/services/note_attachment_opener.dart';
import 'package:front/futures/notes/services/note_image_picker_service.dart';
import 'package:front/futures/notes/widgets/note_attachment_button.dart';
import 'package:front/futures/notes/widgets/note_voice_record_sheet.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class NoteEditorPage extends StatefulWidget {
  final String? noteId;

  const NoteEditorPage({
    super.key,
    this.noteId,
  });

  @override
  State<NoteEditorPage> createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage> {
  final db = DatabaseProvider.instance;

  final NoteImagePickerService _imagePickerService = NoteImagePickerService();
  final NoteAttachmentOpener _attachmentOpener = NoteAttachmentOpener();

  late final String _noteId;
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  List<String> _noteSuggestions = const [];

  bool get isEdit => widget.noteId != null;
  bool _initialized = false;
  int _editorRevision = 0;

  @override
  void initState() {
    super.initState();

    _noteId = widget.noteId ?? const Uuid().v4();

    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    final t = AppLocalizations.of(context)!;

    if (!isEdit) {
      _titleController.text = t.noteCreateTitle;
      _contentController.text = '> ${t.noteContentHint}';
    } else {
      _loadNote();
    }

    _loadNoteSuggestions();
  }

  Future<void> _loadNote() async {
    final note = await (db.select(db.notesTable)
          ..where((t) => t.id.equals(_noteId)))
        .getSingle();

    if (!mounted) return;

    _titleController.text = note.title ?? '';
    _contentController.text = note.content ?? '';
  }

  Future<void> _loadNoteSuggestions() async {
    final notes = await (db.select(db.notesTable)
          ..where((t) => t.deleted.equals(false)))
        .get();

    if (!mounted) return;

    setState(() {
      _noteSuggestions = notes
          .where((note) => note.id != _noteId)
          .map((note) => note.title?.trim())
          .whereType<String>()
          .where((title) => title.isNotEmpty)
          .toSet()
          .toList()
        ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    });
  }

  Future<void> _save() async {
    final now = DateTime.now();

    if (isEdit) {
      await (db.update(db.notesTable)..where((t) => t.id.equals(_noteId)))
          .write(
        NotesTableCompanion(
          title: drift.Value(_titleController.text),
          content: drift.Value(_contentController.text),
          updatedAt: drift.Value(now),
          dirty: const drift.Value(true),
        ),
      );
    } else {
      await db.into(db.notesTable).insert(
            NotesTableCompanion.insert(
              id: _noteId,
              title: drift.Value(_titleController.text),
              content: drift.Value(_contentController.text),
              createdAt: now,
              updatedAt: now,
              dirty: const drift.Value(true),
            ),
          );
    }
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) {
        final t = AppLocalizations.of(context)!;

        return AlertDialog(
          title: Text(t.noteHint),
          content: Text(
            t.noteHelp,
            style: AppText.medium_16a,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(t.noteOk),
            ),
          ],
        );
      },
    );
  }

  void _showImageSourceSheet() {
    final colors = context.colors;
    final t = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Container(
              decoration: BoxDecoration(
                color: colors.bg,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: colors.border,
                  width: 1,
                ),
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
                      Navigator.pop(context);
                      _addImageFromGallery();
                    },
                  ),
                  Divider(
                    height: 1,
                    color: colors.border,
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_camera_rounded),
                    title: Text(t.takePhoto),
                    onTap: () {
                      Navigator.pop(context);
                      _addImageFromCamera();
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _addImageFromGallery() async {
    final result = await _imagePickerService.pickFromGallery(
      noteId: _noteId,
    );

    if (result == null) return;

    _insertAttachmentMarker(result.marker);
  }

  Future<void> _addImageFromCamera() async {
    final result = await _imagePickerService.takePhoto(
      noteId: _noteId,
    );

    if (result == null) return;

    _insertAttachmentMarker(result.marker);
  }

  Future<void> _recordVoiceMessage() async {
    final result = await showModalBottomSheet<NoteAttachmentCreateResult?>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return NoteVoiceRecordSheet(
          noteId: _noteId,
        );
      },
    );

    if (result == null) return;

    _insertAttachmentMarker(result.marker);
  }

  Future<void> _openAttachment(
    MarkdownAttachmentData attachment,
  ) async {
    await _attachmentOpener.open(
      context,
      attachment,
    );
  }

  void _insertAttachmentMarker(String marker) {
    final current = _contentController.text.trimRight();

    final next = current.isEmpty ? marker : '$current\n\n$marker';

    _contentController.value = TextEditingValue(
      text: next,
      selection: TextSelection.collapsed(offset: next.length),
    );

    setState(() {
      _editorRevision++;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.goNamed('notes'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelp,
          ),
          NoteAttachmentButton(
            onAddImage: _showImageSourceSheet,
            onRecordAudio: _recordVoiceMessage,
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              await _save();

              if (context.mounted) {
                context.goNamed('notes');
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: _titleController,
                style: AppText.medium_22a.copyWith(
                  color: colors.text,
                ),
                decoration: InputDecoration(
                  hintText: t.noteTitleLabel,
                  border: InputBorder.none,
                ),
              ),
            ),
            Divider(color: colors.border),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: MarkdownLiveEditor(
                  key: ValueKey(_editorRevision),
                  initialText: _contentController.text,
                  noteSuggestions: _noteSuggestions,
                  onTapAttachment: _openAttachment,
                  onChanged: (value) {
                    _contentController.value = TextEditingValue(
                      text: value,
                      selection: TextSelection.collapsed(offset: value.length),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}