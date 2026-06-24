class SyncPushResultItem {
  final String id;
  final String action;
  final DateTime? serverUpdatedAt;
  final String? message;

  const SyncPushResultItem({
    required this.id,
    required this.action,
    required this.serverUpdatedAt,
    required this.message,
  });

  factory SyncPushResultItem.fromJson(Map<String, dynamic> json) {
    final serverUpdatedAt = json['server_updated_at'];

    return SyncPushResultItem(
      id: json['id'].toString(),
      action: json['action'].toString(),
      serverUpdatedAt: serverUpdatedAt == null
          ? null
          : DateTime.parse(serverUpdatedAt.toString()).toUtc(),
      message: json['message']?.toString(),
    );
  }

  bool get isSuccessfullySynced {
    return action == 'created' || action == 'updated';
  }
}

class SyncPushResponse {
  final List<SyncPushResultItem> notes;
  final List<SyncPushResultItem> reminders;

  const SyncPushResponse({
    required this.notes,
    required this.reminders,
  });

  factory SyncPushResponse.fromJson(Map<String, dynamic> json) {
    return SyncPushResponse(
      notes: _itemsFromJson(json['notes']),
      reminders: _itemsFromJson(json['reminders']),
    );
  }

  static List<SyncPushResultItem> _itemsFromJson(dynamic value) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => SyncPushResultItem.fromJson(
      Map<String, dynamic>.from(item),
    ))
        .toList();
  }

  List<String> get syncedNoteIds {
    return notes
        .where((item) => item.isSuccessfullySynced)
        .map((item) => item.id)
        .toList();
  }

  List<String> get syncedReminderIds {
    return reminders
        .where((item) => item.isSuccessfullySynced)
        .map((item) => item.id)
        .toList();
  }
}