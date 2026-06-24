class NotesListData {
  final List<NoteListItem> notes;
  final List<ReminderListItem> reminders;

  const NotesListData({
    required this.notes,
    required this.reminders,
  });

  factory NotesListData.empty() {
    return const NotesListData(
      notes: [],
      reminders: [],
    );
  }
}

class NoteListItem {
  final String id;
  final String title;
  final String content;
  final DateTime updatedAt;

  const NoteListItem({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
  });
}

class ReminderListItem {
  final String id;
  final String title;
  final DateTime remindAt;
  final bool isDone;

  const ReminderListItem({
    required this.id,
    required this.title,
    required this.remindAt,
    required this.isDone,
  });
}