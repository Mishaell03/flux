class GraphData {
  final List<GraphNode> nodes;
  final List<GraphEdge> edges;

  const GraphData({
    required this.nodes,
    required this.edges,
  });

  factory GraphData.empty() {
    return const GraphData(nodes: [], edges: []);
  }
}

class GraphNode {
  final String id;
  final String title;
  final bool isReminder;

  const GraphNode({
    required this.id,
    required this.title,
    required this.isReminder,
  });
}

class GraphEdge {
  final String fromId;
  final String toId;

  const GraphEdge({
    required this.fromId,
    required this.toId,
  });
}
