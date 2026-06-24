import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';

class NotesSheetHandle extends StatelessWidget {
  const NotesSheetHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 4,
      decoration: BoxDecoration(
        color: context.colors.gray.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}
