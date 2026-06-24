import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/l10n/app_localizations.dart';

enum NotesTab {
  notes,
  reminders,
}

class NotesTabSwitcher extends StatelessWidget {
  final NotesTab selectedTab;
  final ValueChanged<NotesTab> onChanged;

  const NotesTabSwitcher({
    super.key,
    required this.selectedTab,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Container(
      height: 48,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: context.colors.border,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: _NotesTabButton(
              label: t.notesTabNotes,
              selected: selectedTab == NotesTab.notes,
              onTap: () => onChanged(NotesTab.notes),
            ),
          ),
          Expanded(
            child: _NotesTabButton(
              label: t.notesTabReminders,
              selected: selectedTab == NotesTab.reminders,
              onTap: () => onChanged(NotesTab.reminders),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotesTabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NotesTabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: double.infinity,
        decoration: BoxDecoration(
          color: selected ? context.colors.bg : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            label,
            style: AppText.medium_14a.copyWith(
              color: selected ? context.colors.text : context.colors.gray,
            ),
          ),
        ),
      ),
    );
  }
}
