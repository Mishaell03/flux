import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final IconData? actionIcon;
  final VoidCallback? onTap;

  const HomeSectionHeader({
    required this.title,
    this.action,
    this.actionIcon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppText.medium_15a.copyWith(
              color: context.colors.text,
            ),
          ),
        ),
        if (action != null)
          GestureDetector(
            onTap: onTap,
            child: Text(
              action!,
              style: AppText.medium_12a.copyWith(
                color: context.colors.primary,
              ),
            ),
          ),
        if (actionIcon != null)
          GestureDetector(
            onTap: onTap,
            child: Icon(
              actionIcon,
              color: context.colors.text,
              size: 22,
            ),
          ),
      ],
    );
  }
}