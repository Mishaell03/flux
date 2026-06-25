import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/core/db/database.dart';
import 'package:front/core/db/database_provider.dart';
import 'package:front/core/widgets/markdown_live_editor.dart';
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

  final TextEditingController _titleController = TextEditingController();

  String _title = '';
  String _content = '';
  List<String> _noteSuggestions = const [];
  String? _reminderId;
  DateTime? _remindAt;
  bool _initialized = false;

  bool get isEdit => widget.noteId != null;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    if (isEdit) {
      _loadNoteAndReminder();
    } else {
      final t = AppLocalizations.of(context)!;

      _title = t.reminderCreateTitle;
      _content = '> ${t.noteContentHint}';
      _titleController.text = _title;
    }

    _loadNoteSuggestions();
  }

  Future<void> _loadNoteAndReminder() async {
    final note = await (db.select(db.notesTable)
          ..where((table) => table.id.equals(widget.noteId!)))
        .getSingle();

    final reminder = await (db.select(db.remindersTable)
          ..where(
            (table) =>
                table.noteId.equals(widget.noteId!) &
                table.deleted.equals(false),
          )
          ..limit(1))
        .getSingleOrNull();

    if (!mounted) return;

    setState(() {
      _title = note.title ?? '';
      _content = note.content ?? '';
      _reminderId = reminder?.id;
      _remindAt = reminder?.remindAt.toLocal();
      _titleController.text = _title;
    });
  }

  Future<void> _loadNoteSuggestions() async {
    final notes = await (db.select(db.notesTable)
          ..where((table) => table.deleted.equals(false)))
        .get();

    if (!mounted) return;

    setState(() {
      _noteSuggestions = notes
          .where((note) => note.id != widget.noteId)
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

  Future<void> _save() async {
    if (_remindAt == null) {
      await _pickReminderDateTime();
    }

    if (_remindAt == null) return;

    final now = DateTime.now().toUtc();
    final noteId = widget.noteId ?? const Uuid().v4();

    if (isEdit) {
      await (db.update(db.notesTable)
            ..where((table) => table.id.equals(noteId)))
          .write(
        NotesTableCompanion(
          title: drift.Value(_title),
          content: drift.Value(_content),
          updatedAt: drift.Value(now),
          dirty: const drift.Value(true),
        ),
      );
    } else {
      await db.into(db.notesTable).insert(
            NotesTableCompanion.insert(
              id: noteId,
              title: drift.Value(_title),
              content: drift.Value(_content),
              createdAt: now,
              updatedAt: now,
              dirty: const drift.Value(true),
            ),
          );
    }

    if (_reminderId == null) {
      await db.into(db.remindersTable).insert(
            RemindersTableCompanion.insert(
              id: const Uuid().v4(),
              noteId: drift.Value(noteId),
              remindAt: _remindAt!.toUtc(),
              createdAt: now,
              updatedAt: now,
              isDone: const drift.Value(false),
              deleted: const drift.Value(false),
              dirty: const drift.Value(true),
            ),
          );
    } else {
      await (db.update(db.remindersTable)
            ..where((table) => table.id.equals(_reminderId!)))
          .write(
        RemindersTableCompanion(
          noteId: drift.Value(noteId),
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
                onChanged: (value) => _title = value,
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
                  initialText: _content,
                  noteSuggestions: _noteSuggestions,
                  onChanged: (value) => _content = value,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
