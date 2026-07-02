import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/core/db/database.dart';
import 'package:front/core/db/database_provider.dart';
import 'package:front/core/widgets/markdown_live_editor.dart';
import 'package:front/futures/notes/services/note_attachment_flow.dart';
import 'package:front/futures/notes/widgets/note_attachment_button.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ReminderEditorPage extends StatefulWidget {
  final String? noteId;

  const ReminderEditorPage({
    super.key,
    this.noteId,
  });

  @override
  State<ReminderEditorPage> createState() => _ReminderEditorPageState();
}

class _ReminderEditorPageState extends State<ReminderEditorPage> {
  final AppDatabase db = DatabaseProvider.instance;

  late final NoteAttachmentFlow _attachmentFlow;

  late final String _noteId;
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  List<String> _noteSuggestions = const [];

  String? _reminderId;
  DateTime? _remindAt;

  bool _initialized = false;
  bool _noteCreatedLocally = false;

  int _editorRevision = 0;

  bool get isEdit => widget.noteId != null;

  @override
  void initState() {
    super.initState();

    _noteId = widget.noteId ?? const Uuid().v4();
    _noteCreatedLocally = widget.noteId != null;

    _titleController = TextEditingController();
    _contentController = TextEditingController();

    _attachmentFlow = NoteAttachmentFlow(
      noteId: _noteId,
      contentController: _contentController,
      // Перед каждой операцией с вложением — сохраняем заметку,
      // чтобы был валидный noteId в БД для привязки вложения.
      beforeAttachment: _ensureNoteSaved,
      // После вставки маркера — синхронизируем контент в БД.
      afterAttachment: _ensureNoteSaved,
      onContentChanged: () {
        setState(() {
          _editorRevision++;
        });
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    final t = AppLocalizations.of(context)!;

    if (isEdit) {
      _loadNoteAndReminder();
    } else {
      _titleController.text = t.reminderCreateTitle;
      _contentController.text = '> ${t.noteContentHint}';
    }

    _loadNoteSuggestions();
  }

  Future<void> _loadNoteAndReminder() async {
    final note = await (db.select(db.notesTable)
      ..where((table) => table.id.equals(_noteId)))
        .getSingleOrNull();

    final reminder = await (db.select(db.remindersTable)
      ..where(
            (table) =>
        table.noteId.equals(_noteId) & table.deleted.equals(false),
      )
      ..limit(1))
        .getSingleOrNull();

    if (!mounted) return;

    final t = AppLocalizations.of(context)!;

    setState(() {
      if (note == null) {
        _titleController.text = t.reminderCreateTitle;
        _contentController.text = '> ${t.noteContentHint}';
        _noteCreatedLocally = false;
      } else {
        _titleController.text = note.title ?? '';
        _contentController.text = note.content ?? '';
        _noteCreatedLocally = true;
      }

      _reminderId = reminder?.id;
      _remindAt = reminder?.remindAt.toLocal();

      _editorRevision++;
    });
  }

  Future<void> _loadNoteSuggestions() async {
    final notes = await (db.select(db.notesTable)
      ..where((table) => table.deleted.equals(false)))
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

  Future<void> _pickReminderDateTime() async {
    final initial = _remindAt ?? DateTime.now();

    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDate: initial,
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );

    if (time == null) return;

    setState(() {
      _remindAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  /// Гарантирует, что заметка существует в БД перед привязкой вложений.
  Future<void> _ensureNoteSaved() async {
    final now = DateTime.now().toUtc();

    if (_noteCreatedLocally) {
      await (db.update(db.notesTable)
        ..where((table) => table.id.equals(_noteId)))
          .write(
        NotesTableCompanion(
          title: drift.Value(_titleController.text),
          content: drift.Value(_contentController.text),
          updatedAt: drift.Value(now),
          dirty: const drift.Value(true),
        ),
      );
      return;
    }

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

    _noteCreatedLocally = true;
  }

  Future<void> _save() async {
    if (_remindAt == null) {
      await _pickReminderDateTime();
    }

    if (_remindAt == null) return;

    final now = DateTime.now().toUtc();

    await _ensureNoteSaved();

    if (_reminderId == null) {
      final reminderId = const Uuid().v4();

      await db.into(db.remindersTable).insert(
        RemindersTableCompanion.insert(
          id: reminderId,
          noteId: drift.Value(_noteId),
          remindAt: _remindAt!.toUtc(),
          createdAt: now,
          updatedAt: now,
          isDone: const drift.Value(false),
          deleted: const drift.Value(false),
          dirty: const drift.Value(true),
        ),
      );

      _reminderId = reminderId;
    } else {
      await (db.update(db.remindersTable)
        ..where((table) => table.id.equals(_reminderId!)))
          .write(
        RemindersTableCompanion(
          noteId: drift.Value(_noteId),
          remindAt: drift.Value(_remindAt!.toUtc()),
          updatedAt: drift.Value(now),
          dirty: const drift.Value(true),
        ),
      );
    }
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
            icon: const Icon(Icons.schedule_rounded),
            onPressed: _pickReminderDateTime,
          ),
          NoteAttachmentButton(
            onAddImage: () => _attachmentFlow.showImageSourceSheet(context),
            onRecordAudio: () => _attachmentFlow.recordVoiceMessage(context),
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
                  hintText: t.reminderTitleHint,
                  border: InputBorder.none,
                ),
              ),
            ),
            if (_remindAt != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('MMM d, h:mm a').format(_remindAt!),
                    style: AppText.medium_14a.copyWith(
                      color: colors.gray,
                    ),
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
                  onTapAttachment: (attachment) =>
                      _attachmentFlow.openAttachment(context, attachment),
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