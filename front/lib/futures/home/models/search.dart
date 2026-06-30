enum SearchItemType {
  note,
  reminder,
}

class SearchNoteItem {
  final String id;
  final SearchItemType type;
  final String? title;
  final String? description;

  final String? noteId;
  final DateTime? remindAt;
  final String? repeatRule;

  const SearchNoteItem({
    required this.id,
    required this.type,
    this.title,
    this.description,
    this.noteId,
    this.remindAt,
    this.repeatRule,
  });

  bool get isNote => type == SearchItemType.note;
  bool get isReminder => type == SearchItemType.reminder;

  factory SearchNoteItem.fromJson(Map<String, dynamic> json) {
    final rawType = json['type']?.toString();

    return SearchNoteItem(
      id: json['id']?.toString() ?? '',
      type: rawType == 'reminder'
          ? SearchItemType.reminder
          : SearchItemType.note,
      title: json['title']?.toString(),
      description: (json['description'] ??
              json['content'] ??
              json['body'] ??
              json['text'])
          ?.toString(),
      noteId: json['note_id']?.toString(),
      remindAt: json['remind_at'] == null
          ? null
          : DateTime.tryParse(json['remind_at'].toString()),
      repeatRule: json['repeat_rule']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type == SearchItemType.reminder ? 'reminder' : 'note',
        'title': title,
        'description': description,
        'note_id': noteId,
        'remind_at': remindAt?.toIso8601String(),
        'repeat_rule': repeatRule,
      };
}

class SearchResponse {
  final List<SearchNoteItem> notes;

  const SearchResponse({required this.notes});

  factory SearchResponse.fromJson(dynamic json) {
    dynamic rawNotes;

    if (json is List) {
      rawNotes = json;
    } else if (json is Map<String, dynamic>) {
      rawNotes = json['notes'] ??
          json['data'] ??
          json['results'] ??
          json['items'];

      if (rawNotes is Map<String, dynamic>) {
        rawNotes = rawNotes['notes'] ??
            rawNotes['data'] ??
            rawNotes['results'] ??
            rawNotes['items'];
      }
    }

    if (rawNotes is! List) {
      return SearchResponse.empty;
    }

    return SearchResponse(
      notes: rawNotes
          .whereType<Map>()
          .map((e) => SearchNoteItem.fromJson(Map<String, dynamic>.from(e)))
          .where((note) => note.id.isNotEmpty)
          .toList(),
    );
  }

  static const empty = SearchResponse(notes: []);
}