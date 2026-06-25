import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/home/widgets/card.dart';
import 'package:front/futures/home/widgets/section_header.dart';
import 'package:front/l10n/app_localizations.dart';

class HomeMap extends StatelessWidget {
  final int linkedNotesCount;
  final VoidCallback onTap;

  const HomeMap({
    required this.linkedNotesCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return HomeCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HomeSectionHeader(
            title: t.homeMap,
            action: t.homeOpenGraph,
            onTap: onTap,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.account_tree_outlined,
                  color: context.colors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '$linkedNotesCount ${t.homeLinkedNotes}',
                  style: AppText.medium_14a.copyWith(
                    color: context.colors.gray,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 72,
            width: double.infinity,
            child: CustomPaint(
              painter: _KnowledgeMapPainter(
                primary: context.colors.primary,
                warning: context.colors.warning,
                success: context.colors.success,
                gray: context.colors.gray,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KnowledgeMapPainter extends CustomPainter {
  final Color primary;
  final Color warning;
  final Color success;
  final Color gray;

  const _KnowledgeMapPainter({
    required this.primary,
    required this.warning,
    required this.success,
    required this.gray,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = gray.withValues(alpha: 0.22)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final points = [
      Offset(size.width * 0.12, size.height * 0.56),
      Offset(size.width * 0.32, size.height * 0.28),
      Offset(size.width * 0.52, size.height * 0.62),
      Offset(size.width * 0.72, size.height * 0.34),
      Offset(size.width * 0.88, size.height * 0.58),
    ];

    for (var i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], linePaint);
    }

    final colors = [
      primary,
      success,
      primary,
      warning,
      primary,
    ];

    for (var i = 0; i < points.length; i++) {
      final outerPaint = Paint()
        ..color = colors[i].withValues(alpha: 0.16)
        ..style = PaintingStyle.fill;

      final innerPaint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.fill;

      canvas.drawCircle(points[i], 11, outerPaint);
      canvas.drawCircle(points[i], 5, innerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _KnowledgeMapPainter oldDelegate) {
    return oldDelegate.primary != primary ||
        oldDelegate.warning != warning ||
        oldDelegate.success != success ||
        oldDelegate.gray != gray;
  }
}
