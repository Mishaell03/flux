import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';

class HomeCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const HomeCard({
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: context.colors.border,
        borderRadius: BorderRadius.circular(22),
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