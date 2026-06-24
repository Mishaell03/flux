class NoteLinkSyncItem {
  final String fromNoteId;
  final String toNoteId;
  final int weight;
  final DateTime createdAt;

  const NoteLinkSyncItem({
    required this.fromNoteId,
    required this.toNoteId,
    required this.weight,
    required this.createdAt,
  });

  factory NoteLinkSyncItem.fromJson(Map<String, dynamic> json) {
    return NoteLinkSyncItem(
      fromNoteId: json['from_note_id'].toString(),
      toNoteId: json['to_note_id'].toString(),
      weight: (json['weight'] as num?)?.toInt() ?? 1,
      createdAt: DateTime.parse(json['created_at'].toString()).toUtc(),
    );
  }
}