import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';

class NotesCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const NotesCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.colors.border,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );

    if (onTap == null) return card;

    return GestureDetector(
      onTap: onTap,
      child: card,
    );
  }
}

class NotesIconBox extends StatelessWidget {
  final IconData icon;
  final Color color;

  const NotesIconBox({
    super.key,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: color,
        size: 22,
      ),
    );
  }
}

class NotesEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const NotesEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 34),
      decoration: BoxDecoration(
        color: context.colors.border,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          NotesIconBox(
            icon: icon,
            color: context.colors.primary,
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: AppText.medium_15a.copyWith(
              color: context.colors.text,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppText.medium_12a.copyWith(
              color: context.colors.gray,
              height: 1.35,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
