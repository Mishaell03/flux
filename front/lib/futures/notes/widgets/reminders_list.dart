import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/notes/models/notes_list_data.dart';
import 'package:front/futures/notes/widgets/notes_card.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class RemindersList extends StatelessWidget {
  final List<ReminderListItem> reminders;
  final ValueChanged<ReminderListItem> onTap;
  final ValueChanged<ReminderListItem> onDelete;

  const RemindersList({
    super.key,
    required this.reminders,
    required this.onTap,
    required this.onDelete,
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
            onTap: () => onTap(reminder),
            onDelete: () => onDelete(reminder),
          ),
        );
      }),
    );
  }
}

class _ReminderTile extends StatelessWidget {
  final ReminderListItem reminder;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ReminderTile({
    required this.reminder,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return NotesCard(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotesIconBox(
            icon: Icons.notifications_none_rounded,
            color: reminder.isDone
                ? context.colors.success
                : context.colors.primary,
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
                  DateFormat('MMM d, h:mm a')
                      .format(reminder.remindAt.toLocal()),
                  style: AppText.medium_12a.copyWith(
                    color: context.colors.gray,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            children: [
              IconButton(
                tooltip: t.deleteTooltip,
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline_rounded,
                  color: context.colors.error,
                  size: 21,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: context.colors.gray,
                size: 22,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
