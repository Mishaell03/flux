import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/graph/models/graph_data.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class MapGraph extends StatelessWidget {
  final GraphData data;

  const MapGraph({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.border.withValues(alpha: 0.38),
          border: Border.all(color: context.colors.border),
        ),
        child: InteractiveViewer(
          minScale: 0.7,
          maxScale: 2.8,
          boundaryMargin: const EdgeInsets.all(240),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = math.max(constraints.maxWidth, 420.0);
              final height = math.max(constraints.maxHeight, 520.0);
              final size = Size(width, height);
              final positions = _GraphLayout.positions(data.nodes, size);

              return SizedBox(
                width: width,
                height: height,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _MapGraphPainter(
                          data: data,
                          positions: positions,
                          background: context.colors.bg,
                          primary: context.colors.primary,
                          success: context.colors.success,
                          warning: context.colors.warning,
                          text: context.colors.text,
                          gray: context.colors.gray,
                        ),
                      ),
                    ),
                    for (final node in data.nodes)
                      if (positions[node.id] != null)
                        _GraphNodeTapTarget(
                          node: node,
                          center: positions[node.id]!,
                        ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class GraphEmptyState extends StatelessWidget {
  const GraphEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.hub_outlined,
            color: context.colors.gray,
            size: 46,
          ),
          const SizedBox(height: 12),
          Text(
            t.graphEmptyTitle,
            style: AppText.medium_16a.copyWith(
              color: context.colors.text,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            t.graphEmptySubtitle,
            style: AppText.medium_14a.copyWith(
              color: context.colors.gray,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _MapGraphPainter extends CustomPainter {
  final GraphData data;
  final Map<String, Offset> positions;
  final Color background;
  final Color primary;
  final Color success;
  final Color warning;
  final Color text;
  final Color gray;

  const _MapGraphPainter({
    required this.data,
    required this.positions,
    required this.background,
    required this.primary,
    required this.success,
    required this.warning,
    required this.text,
    required this.gray,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final edgePaint = Paint()
      ..color = gray.withValues(alpha: 0.28)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    for (final edge in data.edges) {
      final from = positions[edge.fromId];
      final to = positions[edge.toId];

      if (from == null || to == null) continue;

      canvas.drawLine(from, to, edgePaint);
    }

    for (var i = 0; i < data.nodes.length; i++) {
      final node = data.nodes[i];
      final center = positions[node.id];

      if (center == null) continue;

      final color = primary;

      canvas.drawCircle(
        center,
        30,
        Paint()
          ..color = color.withValues(alpha: 0.14)
          ..style = PaintingStyle.fill,
      );

      canvas.drawCircle(
        center,
        16,
        Paint()
          ..color = color
          ..style = PaintingStyle.fill,
      );

      canvas.drawCircle(
        center,
        16,
        Paint()
          ..color = background.withValues(alpha: 0.18)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );

      if (node.isReminder) {
        _drawReminderMark(canvas, center);
      }

      _drawLabel(canvas, node.title, Offset(center.dx, center.dy + 34));
    }
  }

  void _drawLabel(Canvas canvas, String value, Offset center) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: value,
        style: AppText.medium_12a.copyWith(
          color: text,
        ),
      ),
      maxLines: 1,
      ellipsis: '...',
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 110);

    final offset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    textPainter.paint(canvas, offset);
  }

  void _drawReminderMark(Canvas canvas, Offset center) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '',
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final badgeCenter = Offset(center.dx + 14, center.dy - 14);

    canvas.drawCircle(
      badgeCenter,
      7,
      Paint()
        ..color = warning
        ..style = PaintingStyle.fill,
    );

    textPainter.paint(
      canvas,
      Offset(
        badgeCenter.dx - textPainter.width / 2,
        badgeCenter.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant _MapGraphPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.positions != positions ||
        oldDelegate.background != background ||
        oldDelegate.primary != primary ||
        oldDelegate.success != success ||
        oldDelegate.warning != warning ||
        oldDelegate.text != text ||
        oldDelegate.gray != gray;
  }
}

class _GraphLayout {
  const _GraphLayout._();

  static Map<String, Offset> positions(List<GraphNode> nodes, Size size) {
    final result = <String, Offset>{};
    final count = nodes.length;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) * 0.34;

    for (var i = 0; i < count; i++) {
      final node = nodes[i];
      final angle = (-math.pi / 2) + (2 * math.pi * i / count);
      final wave = 1 + (i.isEven ? 0.08 : -0.08);

      result[node.id] = Offset(
        center.dx + math.cos(angle) * radius * wave,
        center.dy + math.sin(angle) * radius * wave,
      );
    }

    return result;
  }
}

class _GraphNodeTapTarget extends StatelessWidget {
  final GraphNode node;
  final Offset center;

  const _GraphNodeTapTarget({
    required this.node,
    required this.center,
  });

  @override
  Widget build(BuildContext context) {
    const size = 56.0;

    return Positioned(
      left: center.dx - size / 2,
      top: center.dy - size / 2,
      width: size,
      height: size,
      child: Tooltip(
        message: node.title,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            context.goNamed(
              node.isReminder ? 'reminder_edit' : 'note_edit',
              pathParameters: {'id': node.id},
            );
          },
        ),
      ),
    );
  }
}
