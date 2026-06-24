import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/notes/widgets/notes_card.dart';
import 'package:front/futures/notes/widgets/notes_sheet_handle.dart';
import 'package:front/l10n/app_localizations.dart';

class CreateTypeSheet extends StatelessWidget {
  final VoidCallback onCreateNote;
  final VoidCallback onCreateReminder;

  const CreateTypeSheet({
    super.key,
    required this.onCreateNote,
    required this.onCreateReminder,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const NotesSheetHandle(),
            const SizedBox(height: 18),
            _CreateTypeTile(
              icon: Icons.sticky_note_2_outlined,
              title: t.createNote,
              onTap: onCreateNote,
            ),
            const SizedBox(height: 10),
            _CreateTypeTile(
              icon: Icons.notifications_none_rounded,
              title: t.createReminder,
              onTap: onCreateReminder,
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateTypeTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _CreateTypeTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NotesCard(
      onTap: onTap,
      child: Row(
        children: [
          NotesIconBox(
            icon: icon,
            color: context.colors.primary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: AppText.medium_15a.copyWith(
                color: context.colors.text,
              ),
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: context.colors.gray,
            size: 22,
          ),
        ],
      ),
    );
  }
}
