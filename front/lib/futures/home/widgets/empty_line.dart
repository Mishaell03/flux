import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';

class EmptyLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const EmptyLine({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: context.colors.gray,
          size: 20,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: AppText.medium_14a.copyWith(
              color: context.colors.gray,
            ),
            maxLines: 3,
            softWrap: true,
          ),
        ),
      ],
    );
  }
}