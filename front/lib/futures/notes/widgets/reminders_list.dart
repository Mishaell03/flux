import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/notes/models/notes_list_data.dart';
import 'package:front/futures/notes/widgets/notes_card.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class RemindersList extends StatelessWidget {
  final List<ReminderListItem> reminders;
  final VoidCallback onTap;

  const RemindersList({
    super.key,
    required this.reminders,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (reminders.isEmpty) {
      return NotesEmptyState(
        icon: Icons.notifications_none_rounded,
        title: t.remindersEmptyTitle,
        subtitle: t.remindersEmptySubtitle,
      );
    }

    return Column(
      children: List.generate(reminders.length, (index) {
        final reminder = reminders[index];
        final isLast = index == reminders.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
          child: _ReminderTile(
            reminder: reminder,
            onTap: onTap,
          ),
        );
      }),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  final ReminderListItem reminder;
  final VoidCallback onTap;

  const _ReminderTile({
    required this.reminder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NotesCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotesIconBox(
            icon: Icons.notifications_none_rounded,
            color: reminder.isDone ? context.colors.success : context.colors.primary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  style: AppText.medium_15a.copyWith(
                    color: context.colors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('MMM d, h:mm a').format(reminder.remindAt.toLocal()),
                  style: AppText.medium_12a.copyWith(
                    color: context.colors.gray,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
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
