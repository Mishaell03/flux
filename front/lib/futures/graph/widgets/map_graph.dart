import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/graph/models/graph_data.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class MapGraph extends StatefulWidget {
  final GraphData data;

  const MapGraph({
    super.key,
    required this.data,
  });

  @override
  State<MapGraph> createState() => _MapGraphState();
}

class _MapGraphState extends State<MapGraph> {
  final TransformationController _transformationController =
      TransformationController();

  String? _lastSignature;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  String _graphSignature(GraphData data) {
    final nodeIds = data.nodes.map((node) => node.id).toList()..sort();

    final edgeIds = data.edges.map((edge) {
      final pair = [edge.fromId, edge.toId]..sort();
      return '${pair[0]}->${pair[1]}';
    }).toList()
      ..sort();

    return '${nodeIds.join('|')}::${edgeIds.join('|')}';
  }

  void _scheduleFit({
    required Size viewportSize,
    required Size canvasSize,
    required String signature,
  }) {
    if (_lastSignature == signature) return;

    _lastSignature = signature;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final scaleX = viewportSize.width / canvasSize.width;
      final scaleY = viewportSize.height / canvasSize.height;
      final rawScale = math.min(scaleX, scaleY);

      final scale = rawScale >= 0.98
          ? 1.0
          : (rawScale * 0.92).clamp(0.08, 1.0).toDouble();

      final dx = (viewportSize.width - canvasSize.width * scale) / 2;
      final dy = (viewportSize.height - canvasSize.height * scale) / 2;

      _transformationController.value = Matrix4.identity()
        ..translate(dx, dy)
        ..scale(scale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.border.withValues(alpha: 0.38),
          border: Border.all(color: context.colors.border),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final viewportWidth = constraints.hasBoundedWidth
                ? constraints.maxWidth
                : 420.0;

            final viewportHeight = constraints.hasBoundedHeight
                ? constraints.maxHeight
                : 520.0;

            final viewportSize = Size(
              math.max(viewportWidth, 1.0),
              math.max(viewportHeight, 1.0),
            );

            final canvasSize = _GraphLayout.canvasSize(
              nodeCount: widget.data.nodes.length,
              viewportSize: viewportSize,
            );

            final positions = _GraphLayout.positions(
              data: widget.data,
              size: canvasSize,
            );

            final signature = _graphSignature(widget.data);

            _scheduleFit(
              viewportSize: viewportSize,
              canvasSize: canvasSize,
              signature: signature,
            );

            return InteractiveViewer(
              transformationController: _transformationController,
              constrained: false,
              minScale: 0.08,
              maxScale: 4,
              boundaryMargin: const EdgeInsets.all(2400),
              child: SizedBox(
                width: canvasSize.width,
                height: canvasSize.height,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _MapGraphPainter(
                          data: widget.data,
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
                    for (final node in widget.data.nodes)
                      if (positions[node.id] != null)
                        _GraphNodeTapTarget(
                          node: node,
                          center: positions[node.id]!,
                        ),
                  ],
                ),
              ),
            );
          },
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
    _drawGrid(canvas, size);

    final edgePaint = Paint()
      ..color = gray.withValues(alpha: 0.24)
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    for (final edge in data.edges) {
      final from = positions[edge.fromId];
      final to = positions[edge.toId];

      if (from == null || to == null) continue;

      canvas.drawLine(from, to, edgePaint);
    }

    for (final node in data.nodes) {
      final center = positions[node.id];

      if (center == null) continue;

      _drawNode(canvas, node, center);
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gray.withValues(alpha: 0.045)
      ..strokeWidth = 1;

    const step = 72.0;

    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  void _drawNode(
    Canvas canvas,
    GraphNode node,
    Offset center,
  ) {
    final color = primary;

    canvas.drawCircle(
      center,
      34,
      Paint()
        ..color = color.withValues(alpha: 0.09)
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      center,
      22,
      Paint()
        ..color = color.withValues(alpha: 0.16)
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      center,
      13,
      Paint()
        ..color = color
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      center,
      13,
      Paint()
        ..color = background.withValues(alpha: 0.26)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );

    if (node.isReminder) {
      _drawReminderMark(canvas, center);
    }

    _drawLabel(
      canvas,
      node.title,
      Offset(center.dx, center.dy + 38),
    );
  }

  void _drawLabel(
    Canvas canvas,
    String value,
    Offset center,
  ) {
    final normalized = value.trim();

    if (normalized.isEmpty) return;

    final textPainter = TextPainter(
      text: TextSpan(
        text: normalized,
        style: AppText.medium_12a.copyWith(
          color: text,
          height: 1.15,
        ),
      ),
      maxLines: 1,
      ellipsis: '...',
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: 132);

    final textOffset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2,
    );

    final rect = Rect.fromLTWH(
      textOffset.dx - 8,
      textOffset.dy - 4,
      textPainter.width + 16,
      textPainter.height + 8,
    );

    final rrect = RRect.fromRectAndRadius(
      rect,
      const Radius.circular(999),
    );

    canvas.drawRRect(
      rrect,
      Paint()
        ..color = background.withValues(alpha: 0.78)
        ..style = PaintingStyle.fill,
    );

    canvas.drawRRect(
      rrect,
      Paint()
        ..color = gray.withValues(alpha: 0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );

    textPainter.paint(canvas, textOffset);
  }

  void _drawReminderMark(Canvas canvas, Offset center) {
    final badgeCenter = Offset(center.dx + 13, center.dy - 13);

    canvas.drawCircle(
      badgeCenter,
      7,
      Paint()
        ..color = warning
        ..style = PaintingStyle.fill,
    );

    canvas.drawCircle(
      badgeCenter,
      7,
      Paint()
        ..color = background.withValues(alpha: 0.40)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
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

  static Size canvasSize({
    required int nodeCount,
    required Size viewportSize,
  }) {
    if (nodeCount <= 1) {
      return Size(
        math.max(viewportSize.width, 420),
        math.max(viewportSize.height, 520),
      );
    }

    final count = nodeCount.toDouble();

    final side = 520 + math.sqrt(count) * 230 + math.min(count, 80) * 4;

    return Size(
      math.max(viewportSize.width, side),
      math.max(viewportSize.height, side),
    );
  }

  static Map<String, Offset> positions({
    required GraphData data,
    required Size size,
  }) {
    final nodes = [...data.nodes];

    if (nodes.isEmpty) return {};

    if (nodes.length == 1) {
      return {
        nodes.first.id: Offset(
          size.width / 2,
          size.height / 2,
        ),
      };
    }

    final degreeById = <String, int>{
      for (final node in nodes) node.id: 0,
    };

    for (final edge in data.edges) {
      if (degreeById.containsKey(edge.fromId)) {
        degreeById[edge.fromId] = degreeById[edge.fromId]! + 1;
      }

      if (degreeById.containsKey(edge.toId)) {
        degreeById[edge.toId] = degreeById[edge.toId]! + 1;
      }
    }

    nodes.sort((a, b) {
      final byDegree = (degreeById[b.id] ?? 0).compareTo(
        degreeById[a.id] ?? 0,
      );

      if (byDegree != 0) return byDegree;

      final byTitle = a.title.toLowerCase().compareTo(
            b.title.toLowerCase(),
          );

      if (byTitle != 0) return byTitle;

      return a.id.compareTo(b.id);
    });

    final center = Offset(size.width / 2, size.height / 2);

    final positions = <String, Offset>{};

    final goldenAngle = math.pi * (3 - math.sqrt(5));

    final initialSpacing = nodes.length <= 12 ? 92.0 : 84.0;

    for (var i = 0; i < nodes.length; i++) {
      final node = nodes[i];

      if (i == 0) {
        positions[node.id] = center;
        continue;
      }

      final angle = i * goldenAngle;
      final radius = initialSpacing * math.sqrt(i);

      positions[node.id] = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
    }

    final margin = math.min(
      190.0,
      math.min(size.width, size.height) * 0.22,
    );

    final minDistance = nodes.length <= 20
        ? 138.0
        : nodes.length <= 60
            ? 124.0
            : 112.0;

    final edgeLength = nodes.length <= 20
        ? 210.0
        : nodes.length <= 60
            ? 178.0
            : 150.0;

    final iterations = nodes.length <= 40
        ? 440
        : nodes.length <= 100
            ? 320
            : 240;

    final repulsionStrength = minDistance * minDistance * 1.45;
    const springStrength = 0.020;
    const centerStrength = 0.0045;

    final ids = nodes.map((node) => node.id).toList();

    final indexById = <String, int>{
      for (var i = 0; i < ids.length; i++) ids[i]: i,
    };

    for (var iteration = 0; iteration < iterations; iteration++) {
      final forces = <String, Offset>{
        for (final id in ids) id: Offset.zero,
      };

      for (var i = 0; i < ids.length; i++) {
        for (var j = i + 1; j < ids.length; j++) {
          final firstId = ids[i];
          final secondId = ids[j];

          final first = positions[firstId]!;
          final second = positions[secondId]!;

          var delta = first - second;
          var distance = delta.distance;

          if (distance < 0.01) {
            final angle = (i + j + 1) * goldenAngle;
            delta = Offset(
              math.cos(angle),
              math.sin(angle),
            );
            distance = 1;
          }

          final direction = delta / distance;
          final distanceSquared = math.max(distance * distance, 1.0);

          final repulsion = repulsionStrength / distanceSquared;
          final repulsionForce = direction * repulsion;

          forces[firstId] = forces[firstId]! + repulsionForce;
          forces[secondId] = forces[secondId]! - repulsionForce;

          if (distance < minDistance) {
            final collisionForce = direction * ((minDistance - distance) * 0.18);

            forces[firstId] = forces[firstId]! + collisionForce;
            forces[secondId] = forces[secondId]! - collisionForce;
          }
        }
      }

      for (final edge in data.edges) {
        if (!positions.containsKey(edge.fromId) ||
            !positions.containsKey(edge.toId)) {
          continue;
        }

        final from = positions[edge.fromId]!;
        final to = positions[edge.toId]!;

        var delta = to - from;
        var distance = delta.distance;

        if (distance < 0.01) {
          final index = indexById[edge.fromId] ?? 0;
          final angle = (index + 1) * goldenAngle;

          delta = Offset(
            math.cos(angle),
            math.sin(angle),
          );

          distance = 1;
        }

        final direction = delta / distance;
        final springForce = direction * ((distance - edgeLength) * springStrength);

        forces[edge.fromId] = forces[edge.fromId]! + springForce;
        forces[edge.toId] = forces[edge.toId]! - springForce;
      }

      for (final id in ids) {
        final position = positions[id]!;
        final centerForce = (center - position) * centerStrength;

        forces[id] = forces[id]! + centerForce;
      }

      final progress = iteration / math.max(iterations - 1, 1);
      final cooling = 1.0 - progress;
      final maxStep = 22.0 * cooling + 1.2;

      for (final id in ids) {
        final force = _limit(forces[id]!, maxStep);
        final next = positions[id]! + force;

        positions[id] = Offset(
          next.dx.clamp(margin, size.width - margin).toDouble(),
          next.dy.clamp(margin, size.height - margin).toDouble(),
        );
      }
    }

    _resolveCollisions(
      ids: ids,
      positions: positions,
      minDistance: minDistance,
      size: size,
      margin: margin,
    );

    return positions;
  }

  static void _resolveCollisions({
    required List<String> ids,
    required Map<String, Offset> positions,
    required double minDistance,
    required Size size,
    required double margin,
  }) {
    for (var pass = 0; pass < 90; pass++) {
      var changed = false;

      for (var i = 0; i < ids.length; i++) {
        for (var j = i + 1; j < ids.length; j++) {
          final firstId = ids[i];
          final secondId = ids[j];

          final first = positions[firstId]!;
          final second = positions[secondId]!;

          var delta = first - second;
          var distance = delta.distance;

          if (distance < 0.01) {
            final angle = (i + j + 1) * math.pi * 0.61803398875;
            delta = Offset(
              math.cos(angle),
              math.sin(angle),
            );
            distance = 1;
          }

          if (distance >= minDistance) continue;

          final direction = delta / distance;
          final push = direction * ((minDistance - distance) / 2);

          final nextFirst = first + push;
          final nextSecond = second - push;

          positions[firstId] = Offset(
            nextFirst.dx.clamp(margin, size.width - margin).toDouble(),
            nextFirst.dy.clamp(margin, size.height - margin).toDouble(),
          );

          positions[secondId] = Offset(
            nextSecond.dx.clamp(margin, size.width - margin).toDouble(),
            nextSecond.dy.clamp(margin, size.height - margin).toDouble(),
          );

          changed = true;
        }
      }

      if (!changed) return;
    }
  }

  static Offset _limit(Offset value, double maxLength) {
    final length = value.distance;

    if (length <= maxLength || length <= 0.0001) {
      return value;
    }

    return value / length * maxLength;
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
    const width = 150.0;
    const height = 92.0;

    return Positioned(
      left: center.dx - width / 2,
      top: center.dy - 34,
      width: width,
      height: height,
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