import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/core/db/database.dart';
import 'package:front/core/db/database_provider.dart';
import 'package:front/core/widgets/markdown_live_editor.dart';
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

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  List<String> _noteSuggestions = const [];

  bool get isEdit => widget.noteId != null;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
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
          ..where((t) => t.id.equals(widget.noteId!)))
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
          .where((note) => note.id != widget.noteId)
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
      await (db.update(db.notesTable)
            ..where((t) => t.id.equals(widget.noteId!)))
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
              id: const Uuid().v4(),
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
                  initialText: _contentController.text,
                  noteSuggestions: _noteSuggestions,
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