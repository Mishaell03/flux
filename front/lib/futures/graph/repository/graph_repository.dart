import 'dart:async';

import 'package:front/core/db/database.dart';
import 'package:front/core/db/database_provider.dart';
import 'package:front/futures/graph/models/graph_data.dart';

class GraphRepository {
  final AppDatabase db;

  GraphRepository({
    AppDatabase? db,
  }) : db = db ?? DatabaseProvider.instance;

  Stream<GraphData> watchGraphData() {
    final controller = StreamController<GraphData>();
    final subscriptions = <StreamSubscription>[];

    Future<void> emit() async {
      if (controller.isClosed) return;

      final data = await loadGraphData();

      if (!controller.isClosed) {
        controller.add(data);
      }
    }

    controller.onListen = () {
      subscriptions.addAll([
        db.select(db.notesTable).watch().listen((_) => emit()),
        db.select(db.remindersTable).watch().listen((_) => emit()),
      ]);

      emit();
    };

    controller.onCancel = () async {
      for (final subscription in subscriptions) {
        await subscription.cancel();
      }
    };

    return controller.stream;
  }

  Future<GraphData> loadGraphData() async {
    final notes = await (db.select(db.notesTable)
          ..where((table) => table.deleted.equals(false)))
        .get();

    final reminders = await (db.select(db.remindersTable)
          ..where((table) => table.deleted.equals(false)))
        .get();

    final reminderNoteIds = reminders
        .where((reminder) => reminder.noteId != null)
        .map((reminder) => reminder.noteId!)
        .toSet();

    final nodesById = <String, GraphNode>{};
    final titleToId = <String, String>{};
    final tagsByNoteId = <String, Set<String>>{};

    for (final note in notes) {
      final title = _safeTitle(note.title);

      nodesById[note.id] = GraphNode(
        id: note.id,
        title: title,
        isReminder: reminderNoteIds.contains(note.id),
      );

      titleToId[title.trim()] = note.id;
      tagsByNoteId[note.id] = _extractHashtags(note.content ?? '');
    }

    final edges = <GraphEdge>[];
    final edgeKeys = <String>{};

    for (final note in notes) {
      final targets = _extractWikiTargets(note.content ?? '');

      for (final target in targets) {
        final targetId = _resolveTargetId(target, titleToId);

        if (targetId == null || targetId == note.id) continue;
        if (!nodesById.containsKey(targetId)) continue;

        _addEdge(
          edges: edges,
          edgeKeys: edgeKeys,
          fromId: note.id,
          toId: targetId,
        );
      }
    }

    final noteIds = tagsByNoteId.keys.toList();

    for (var i = 0; i < noteIds.length; i++) {
      for (var j = i + 1; j < noteIds.length; j++) {
        final firstId = noteIds[i];
        final secondId = noteIds[j];
        final firstTags = tagsByNoteId[firstId] ?? const <String>{};
        final secondTags = tagsByNoteId[secondId] ?? const <String>{};

        if (firstTags.intersection(secondTags).isEmpty) continue;

        _addEdge(
          edges: edges,
          edgeKeys: edgeKeys,
          fromId: firstId,
          toId: secondId,
        );
      }
    }

    return GraphData(nodes: nodesById.values.toList(), edges: edges);
  }

  void _addEdge({
    required List<GraphEdge> edges,
    required Set<String> edgeKeys,
    required String fromId,
    required String toId,
  }) {
    final sorted = [fromId, toId]..sort();
    final edgeKey = '${sorted.first}->${sorted.last}';

    if (edgeKeys.add(edgeKey)) {
      edges.add(GraphEdge(fromId: fromId, toId: toId));
    }
  }

  Set<String> _extractHashtags(String content) {
    return RegExp(r'(^|\s)#([\p{L}\p{N}_-]+)', unicode: true)
        .allMatches(content)
        .map((match) => match.group(2)!.toLowerCase())
        .toSet();
  }

  Set<String> _extractWikiTargets(String content) {
    return RegExp(r'\[\[([^\]]+)\]\]')
        .allMatches(content)
        .map((match) => _normalizeWikiTarget(match.group(1)!))
        .where((target) => target.isNotEmpty)
        .toSet();
  }

  String _normalizeWikiTarget(String rawLink) {
    final parts = rawLink
        .split('|')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '';

    for (final part in parts) {
      if (_isUrl(part)) return '';
    }

    return parts.first;
  }

  String? _resolveTargetId(String target, Map<String, String> titleToId) {
    if (_looksLikeUuid(target)) return target;

    return titleToId[target.trim()];
  }

  String _safeTitle(String? value) {
    final text = value?.trim();

    if (text == null || text.isEmpty) {
      return '';
    }

    return text;
  }

  bool _isUrl(String value) {
    final text = value.trim().toLowerCase();

    return text.startsWith('http://') || text.startsWith('https://');
  }

  bool _looksLikeUuid(String value) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(value);
  }
}
