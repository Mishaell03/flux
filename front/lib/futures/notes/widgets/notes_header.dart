import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/l10n/app_localizations.dart';

class NotesHeader extends StatelessWidget {
  final VoidCallback onCreate;

  const NotesHeader({
    super.key,
    required this.onCreate,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Row(
      children: [
        Expanded(
          child: Text(
            t.notesPageTitle,
            style: AppText.bold_24.copyWith(
              color: context.colors.text,
              fontSize: 28,
              height: 1.1,
            ),
          ),
        ),
        GestureDetector(
          onTap: onCreate,
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: context.colors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.add_rounded,
                  color: context.colors.text,
                  size: 20,
                ),
                const SizedBox(width: 6),
                Text(
                  t.notesCreateNew,
                  style: AppText.medium_14a.copyWith(
                    color: context.colors.text,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
