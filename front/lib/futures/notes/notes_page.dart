import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/scroll.dart';
import 'package:front/futures/notes/models/notes_list_data.dart';
import 'package:front/futures/notes/repository/notes_repository.dart';
import 'package:front/futures/notes/services/local_notes_service.dart';
import 'package:front/futures/notes/widgets/notes_header.dart';
import 'package:front/futures/notes/widgets/notes_list.dart';
import 'package:front/futures/notes/widgets/notes_tab_switcher.dart';
import 'package:front/futures/notes/widgets/reminders_list.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

const double _kMaxContentWidth = 560;

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPage();
}

class _NotesPage extends State<NotesPage> {
  final NotesRepository _repository = NotesRepository();
  final LocalNotesService _localNotesService = LocalNotesService();

  late final Stream<NotesListData> _stream;

  NotesTab _selectedTab = NotesTab.notes;

  @override
  void initState() {
    super.initState();

    _stream = _repository.watchListData();
  }

  void _selectTab(NotesTab tab) {
    setState(() {
      _selectedTab = tab;
    });
  }

  void _createNote() {
    final t = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final colors = context.colors;

        return Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            child: Container(
              color: colors.bg,
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Icon(Icons.note_add, color: colors.text),
                        title: Text(t.createNote),
                        onTap: () {
                          Navigator.pop(context);
                          context.goNamed('note_new');
                        },
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: ListTile(
                        leading: Icon(Icons.alarm, color: colors.text),
                        title: Text(t.createReminder),
                        onTap: () {
                          Navigator.pop(context);
                          context.goNamed('reminder_new');
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _openNote(NoteListItem note) {
    context.goNamed(
      'note_edit',
      pathParameters: {'id': note.id},
    );
  }

  void _openReminder(ReminderListItem reminder) {
    final noteId = reminder.noteId;

    if (noteId == null || noteId.isEmpty) return;

    context.goNamed(
      'reminder_edit',
      pathParameters: {'id': noteId},
    );
  }

  Future<void> _deleteNote(NoteListItem note) async {
    final t = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.deleteNoteTitle),
          content: Text(t.deleteNoteMessage(note.title)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(t.noteCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(t.deleteTooltip),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await _localNotesService.destroyNote(id: note.id);
  }

  Future<void> _deleteReminder(ReminderListItem reminder) async {
    final t = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.deleteReminderTitle),
          content: Text(t.deleteReminderMessage(reminder.title)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(t.noteCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(t.deleteTooltip),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await _localNotesService.destroyReminder(id: reminder.id);
  }

  @override
  Widget build(BuildContext context) {
    return AppVerticalScroll(
      paddingH: 20,
      paddingV: 0,
      isCenter: false,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _kMaxContentWidth),
        child: StreamBuilder<NotesListData>(
          stream: _stream,
          builder: (context, snapshot) {
            final data = snapshot.data ?? NotesListData.empty();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                NotesHeader(
                  onCreate: _createNote,
                ),
                const SizedBox(height: 18),
                NotesTabSwitcher(
                  selectedTab: _selectedTab,
                  onChanged: _selectTab,
                ),
                const SizedBox(height: 18),
                if (_selectedTab == NotesTab.notes)
                  NotesList(
                    notes: data.notes,
                    onTap: _openNote,
                    onDelete: _deleteNote,
                  )
                else
                  RemindersList(
                    reminders: data.reminders,
                    onTap: _openReminder,
                    onDelete: _deleteReminder,
                  ),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }
}
