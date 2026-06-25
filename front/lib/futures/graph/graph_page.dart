import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/graph/models/graph_data.dart';
import 'package:front/futures/graph/repository/graph_repository.dart';
import 'package:front/futures/graph/widgets/map_graph.dart';
import 'package:front/l10n/app_localizations.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({super.key});

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  final GraphRepository _repository = GraphRepository();

  late final Stream<GraphData> _stream;

  @override
  void initState() {
    super.initState();
    _stream = _repository.watchGraphData();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.bg,
      body: SafeArea(
        child: StreamBuilder<GraphData>(
          stream: _stream,
          builder: (context, snapshot) {
            final data = snapshot.data ?? GraphData.empty();

            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    t.graphTitle,
                    style: AppText.bold_30.copyWith(
                      color: context.colors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    t.graphStats(data.nodes.length, data.edges.length),
                    style: AppText.medium_14a.copyWith(
                      color: context.colors.gray,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: data.nodes.isEmpty
                        ? const GraphEmptyState()
                        : MapGraph(data: data),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
