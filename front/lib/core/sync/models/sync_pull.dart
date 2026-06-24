class SyncPullNote {
  final String id;
  final String? title;
  final String? content;
  final bool deleted;
  final DateTime? deletedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SyncPullNote({
    required this.id,
    required this.title,
    required this.content,
    required this.deleted,
    required this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SyncPullNote.fromJson(Map<String, dynamic> json) {
    return SyncPullNote(
      id: json['id'].toString(),
      title: json['title']?.toString(),
      content: json['content']?.toString(),
      deleted: json['deleted'] == true,
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'].toString()).toUtc(),
      createdAt: DateTime.parse(json['created_at'].toString()).toUtc(),
      updatedAt: DateTime.parse(json['updated_at'].toString()).toUtc(),
    );
  }
}

class SyncPullReminder {
  final String id;
  final String? noteId;
  final DateTime remindAt;
  final String? repeatRule;
  final bool isDone;
  final bool deleted;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SyncPullReminder({
    required this.id,
    required this.noteId,
    required this.remindAt,
    required this.repeatRule,
    required this.isDone,
    required this.deleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SyncPullReminder.fromJson(Map<String, dynamic> json) {
    return SyncPullReminder(
      id: json['id'].toString(),
      noteId: json['note_id']?.toString(),
      remindAt: DateTime.parse(json['remind_at'].toString()).toUtc(),
      repeatRule: json['repeat_rule']?.toString(),
      isDone: json['is_done'] == true,
      deleted: json['deleted'] == true,
      createdAt: DateTime.parse(json['created_at'].toString()).toUtc(),
      updatedAt: DateTime.parse(json['updated_at'].toString()).toUtc(),
    );
  }
}

class SyncPullResponse {
  final List<SyncPullNote> notes;
  final List<SyncPullReminder> reminders;

  const SyncPullResponse({
    required this.notes,
    required this.reminders,
  });

  factory SyncPullResponse.fromJson(Map<String, dynamic> json) {
    return SyncPullResponse(
      notes: _notesFromJson(json['notes']),
      reminders: _remindersFromJson(json['reminders']),
    );
  }

  static List<SyncPullNote> _notesFromJson(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => SyncPullNote.fromJson(
      Map<String, dynamic>.from(item),
    ))
        .toList();
  }

  static List<SyncPullReminder> _remindersFromJson(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => SyncPullReminder.fromJson(
      Map<String, dynamic>.from(item),
    ))
        .toList();
  }
}