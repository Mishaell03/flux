import 'package:flutter/material.dart';
import 'package:front/core/components/scroll.dart';
import 'package:front/futures/notes/models/notes_list_data.dart';
import 'package:front/futures/notes/repository/notes_repository.dart';
import 'package:front/futures/notes/widgets/notes_header.dart';
import 'package:front/futures/notes/widgets/notes_list.dart';
import 'package:front/futures/notes/widgets/notes_tab_switcher.dart';
import 'package:front/futures/notes/widgets/reminders_list.dart';

const double _kMaxContentWidth = 560;

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPage();
}

class _NotesPage extends State<NotesPage> {
  final NotesRepository _repository = NotesRepository();

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
    // TODO: открыть экран создания заметки, когда будет готов NoteEditorPage.
  }

  void _openNote(NoteListItem note) {
    // TODO: открыть экран просмотра/редактирования заметки.
  }

  void _openReminderPlaceholder() {
    // TODO: открыть экран просмотра/редактирования напоминания.
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
                  )
                else
                  RemindersList(
                    reminders: data.reminders,
                    onTap: _openReminderPlaceholder,
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
