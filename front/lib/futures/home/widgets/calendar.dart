import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/home/models/home_dashboard.dart';
import 'package:front/futures/home/widgets/card.dart';
import 'package:front/futures/home/widgets/empty_line.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class HomeCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final DateTime weekStart;
  final Set<String> reminderDayKeys;
  final List<HomeReminderPreview> reminders;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPreviousWeek;
  final VoidCallback onNextWeek;

  const HomeCalendar({
    required this.selectedDate,
    required this.weekStart,
    required this.reminderDayKeys,
    required this.reminders,
    required this.onDateSelected,
    required this.onPreviousWeek,
    required this.onNextWeek,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return HomeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  t.homeUpcomingReminders,
                  style: AppText.medium_15a.copyWith(
                    color: context.colors.text,
                  ),
                ),
              ),
              _WeekButton(
                icon: Icons.chevron_left_rounded,
                onTap: onPreviousWeek,
              ),
              const SizedBox(width: 8),
              Text(
                _selectedDateText(context, selectedDate),
                style: AppText.medium_12a.copyWith(
                  color: context.colors.gray,
                ),
              ),
              const SizedBox(width: 8),
              _WeekButton(
                icon: Icons.chevron_right_rounded,
                onTap: onNextWeek,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _CalendarStrip(
            weekStart: weekStart,
            selectedDate: selectedDate,
            reminderDayKeys: reminderDayKeys,
            onDateSelected: onDateSelected,
          ),
          const SizedBox(height: 16),
          if (reminders.isEmpty)
            EmptyLine(
              icon: Icons.notifications_none_rounded,
              text: t.homeNoReminders,
            )
          else
            Column(
              children: reminders.map((reminder) {
                final isLast = reminder == reminders.last;

                return Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
                  child: _ReminderRow(reminder: reminder),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }

  String _selectedDateText(BuildContext context, DateTime date) {
    final t = AppLocalizations.of(context)!;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);

    if (selected == today) return t.homeToday;

    return DateFormat('MMM d').format(selected);
  }
}

class _WeekButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _WeekButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: context.colors.bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: context.colors.text,
        ),
      ),
    );
  }
}

class _CalendarStrip extends StatelessWidget {
  final DateTime weekStart;
  final DateTime selectedDate;
  final Set<String> reminderDayKeys;
  final ValueChanged<DateTime> onDateSelected;

  const _CalendarStrip({
    required this.weekStart,
    required this.selectedDate,
    required this.reminderDayKeys,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (index) {
      return weekStart.add(Duration(days: index));
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((date) {
        final selected = _isSameDay(date, selectedDate);
        final hasReminder = reminderDayKeys.contains(_dateKey(date));

        return _CalendarDay(
          date: date,
          selected: selected,
          hasReminder: hasReminder,
          onTap: () => onDateSelected(date),
        );
      }).toList(),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String _dateKey(DateTime date) {
    final local = date.toLocal();

    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');

    return '$y-$m-$d';
  }
}

class _CalendarDay extends StatelessWidget {
  final DateTime date;
  final bool selected;
  final bool hasReminder;
  final VoidCallback onTap;

  const _CalendarDay({
    required this.date,
    required this.selected,
    required this.hasReminder,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = DateFormat('E').format(date).substring(0, 2);
    final day = date.day.toString();

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 34,
        child: Column(
          children: [
            Text(
              label,
              style: AppText.medium_12a.copyWith(
                color: selected ? context.colors.primary : context.colors.gray,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: selected ? context.colors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  day,
                  style: AppText.medium_12a.copyWith(
                    color: selected ? context.colors.bg : context.colors.text,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color:
                hasReminder ? context.colors.primary : Colors.transparent,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderRow extends StatelessWidget {
  final HomeReminderPreview reminder;

  const _ReminderRow({
    required this.reminder,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: context.colors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: context.colors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            size: 18,
            color: context.colors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                reminder.title,
                style: AppText.medium_14a.copyWith(
                  color: context.colors.text,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('MMM d, h:mm a').format(reminder.remindAt.toLocal()),
                style: AppText.medium_12a.copyWith(
                  color: context.colors.gray,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: context.colors.bg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            _timeLeft(reminder.remindAt),
            style: AppText.medium_12a.copyWith(
              color: context.colors.gray,
            ),
          ),
        ),
      ],
    );
  }

  String _timeLeft(DateTime value) {
    final now = DateTime.now();
    final diff = value.toLocal().difference(now);

    if (diff.inMinutes <= 0) return 'now';
    if (diff.inHours < 1) return 'in ${diff.inMinutes}m';
    if (diff.inDays < 1) return 'in ${diff.inHours}h';

    return 'in ${diff.inDays}d';
  }
}