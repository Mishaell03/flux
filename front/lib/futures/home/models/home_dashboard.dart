class HomeDashboardData {
  final int notesCount;
  final int remindersCount;
  final int linkedNotesCount;
  final List<HomeNotePreview> recentNotes;
  final List<HomeReminderPreview> upcomingReminders;
  final List<HomeReminderPreview> allReminders;
  final Set<String> reminderDayKeys;

  const HomeDashboardData({
    required this.notesCount,
    required this.remindersCount,
    required this.linkedNotesCount,
    required this.recentNotes,
    required this.upcomingReminders,
    required this.allReminders,
    required this.reminderDayKeys,
  });

  factory HomeDashboardData.empty() {
    return const HomeDashboardData(
      notesCount: 0,
      remindersCount: 0,
      linkedNotesCount: 0,
      recentNotes: [],
      upcomingReminders: [],
      allReminders: [],
      reminderDayKeys: {},
    );
  }
}

class HomeNotePreview {
  final String id;
  final String title;
  final String content;
  final DateTime updatedAt;

  const HomeNotePreview({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
  });
}

class HomeReminderPreview {
  final String id;
  final String title;
  final DateTime remindAt;

  const HomeReminderPreview({
    required this.id,
    required this.title,
    required this.remindAt,
  });
}