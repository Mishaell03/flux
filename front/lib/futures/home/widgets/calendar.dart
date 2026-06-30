import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/home/models/home_dashboard.dart';
import 'package:front/futures/home/widgets/card.dart';
import 'package:front/futures/home/widgets/empty_line.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class HomeCalendar extends StatefulWidget {
  final DateTime selectedDate;
  final List<HomeReminderPreview> allReminders;
  final ValueChanged<DateTime> onDateSelected;

  const HomeCalendar({
    super.key,
    required this.selectedDate,
    required this.allReminders,
    required this.onDateSelected,
  });

  @override
  State<HomeCalendar> createState() => _HomeCalendarState();
}

class _HomeCalendarState extends State<HomeCalendar> {
  static const int _pageAnchorOffset = 1200;

  late DateTime _weekStart;
  late DateTime _focusedMonth;
  late PageController _monthPageController;
  bool _expanded = false;

  @override
  void initState() {
    super.initState();
    _weekStart = _mondayOf(widget.selectedDate);
    _focusedMonth =
        DateTime(widget.selectedDate.year, widget.selectedDate.month);
    _monthPageController = PageController(initialPage: _pageAnchorOffset);
  }

  @override
  void didUpdateWidget(covariant HomeCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isSameDay(oldWidget.selectedDate, widget.selectedDate)) {
      final newWeekStart = _mondayOf(widget.selectedDate);
      if (!_isSameDay(newWeekStart, _weekStart)) {
        setState(() => _weekStart = newWeekStart);
      }
    }
  }

  @override
  void dispose() {
    _monthPageController.dispose();
    super.dispose();
  }

  DateTime _mondayOf(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _dateKey(DateTime date) {
    final local = date.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Map<String, int> get _reminderCountsByDay {
    final map = <String, int>{};
    for (final reminder in widget.allReminders) {
      final key = _dateKey(reminder.remindAt);
      map[key] = (map[key] ?? 0) + 1;
    }
    return map;
  }

  List<HomeReminderPreview> get _remindersForSelectedDate {
    final list = widget.allReminders
        .where((r) => _isSameDay(r.remindAt.toLocal(), widget.selectedDate))
        .toList()
      ..sort((a, b) => a.remindAt.compareTo(b.remindAt));
    return list;
  }

  void _goToPreviousWeek() {
    setState(() => _weekStart = _weekStart.subtract(const Duration(days: 7)));
  }

  void _goToNextWeek() {
    setState(() => _weekStart = _weekStart.add(const Duration(days: 7)));
  }

  DateTime _monthForPage(int index) {
    final monthOffset = index - _pageAnchorOffset;
    final anchor = DateTime.now();
    return DateTime(anchor.year, anchor.month + monthOffset);
  }

  void _onMonthPageChanged(int index) {
    setState(() => _focusedMonth = _monthForPage(index));
  }

  void _toggleExpanded() {
    final wasExpanded = _expanded;
    setState(() => _expanded = !_expanded);

    if (!wasExpanded) {
      final anchor = DateTime.now();
      final monthDiff = (widget.selectedDate.year - anchor.year) * 12 +
          (widget.selectedDate.month - anchor.month);
      final targetPage = _pageAnchorOffset + monthDiff;

      _focusedMonth =
          DateTime(widget.selectedDate.year, widget.selectedDate.month);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_monthPageController.hasClients) {
          _monthPageController.jumpToPage(targetPage);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final counts = _reminderCountsByDay;
    final reminders = _remindersForSelectedDate;

    return HomeCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  t.homeUpcomingReminders,
                  style:
                      AppText.medium_15a.copyWith(color: context.colors.text),
                ),
              ),
              if (!_expanded) ...[
                _WeekButton(
                    icon: Icons.chevron_left_rounded, onTap: _goToPreviousWeek),
                const SizedBox(width: 8),
                Text(
                  _selectedDateText(context, widget.selectedDate),
                  style:
                      AppText.medium_12a.copyWith(color: context.colors.gray),
                ),
                const SizedBox(width: 8),
                _WeekButton(
                    icon: Icons.chevron_right_rounded, onTap: _goToNextWeek),
                const SizedBox(width: 8),
              ],
              _WeekButton(
                icon: _expanded
                    ? Icons.keyboard_arrow_up_rounded
                    : Icons.keyboard_arrow_down_rounded,
                onTap: _toggleExpanded,
              ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: _expanded
                ? _MonthView(
                    key: const ValueKey('month'),
                    pageController: _monthPageController,
                    focusedMonth: _focusedMonth,
                    selectedDate: widget.selectedDate,
                    reminderCounts: counts,
                    monthForPage: _monthForPage,
                    onPageChanged: _onMonthPageChanged,
                    onDateSelected: widget.onDateSelected,
                  )
                : _CalendarStrip(
                    key: const ValueKey('week'),
                    weekStart: _weekStart,
                    selectedDate: widget.selectedDate,
                    reminderCounts: counts,
                    onDateSelected: widget.onDateSelected,
                  ),
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
    if (_isSameDay(selected, today)) return t.homeToday;
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
  final Map<String, int> reminderCounts;
  final ValueChanged<DateTime> onDateSelected;

  const _CalendarStrip({
    super.key,
    required this.weekStart,
    required this.selectedDate,
    required this.reminderCounts,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final days =
        List.generate(7, (index) => weekStart.add(Duration(days: index)));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((date) {
        final selected = _isSameDay(date, selectedDate);
        final count = reminderCounts[_dateKey(date)] ?? 0;

        return _CalendarDay(
          date: date,
          selected: selected,
          reminderCount: count,
          onTap: () => onDateSelected(date),
        );
      }).toList(),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

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
  final int reminderCount;
  final VoidCallback onTap;

  const _CalendarDay({
    required this.date,
    required this.selected,
    required this.reminderCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final label = DateFormat('E').format(date).substring(0, 2);
    final day = date.day.toString();
    final hasReminders = reminderCount > 0;
    final badgeText = reminderCount > 9 ? '9+' : reminderCount.toString();

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
                color: selected
                    ? context.colors.primary
                    : context.colors.transparent,
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
            const SizedBox(height: 4),
            SizedBox(
              height: 14,
              child: hasReminders
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: selected
                            ? context.colors.primary
                            : context.colors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badgeText,
                        style: AppText.medium_12a.copyWith(
                          fontSize: 9,
                          color: selected
                              ? context.colors.bg
                              : context.colors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthView extends StatelessWidget {
  final PageController pageController;
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final Map<String, int> reminderCounts;
  final DateTime Function(int index) monthForPage;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<DateTime> onDateSelected;

  const _MonthView({
    super.key,
    required this.pageController,
    required this.focusedMonth,
    required this.selectedDate,
    required this.reminderCounts,
    required this.monthForPage,
    required this.onPageChanged,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMMM yyyy').format(focusedMonth),
              style: AppText.medium_14a.copyWith(color: context.colors.text),
            ),
            Row(
              children: [
                _WeekButton(
                  icon: Icons.chevron_left_rounded,
                  onTap: () => pageController.previousPage(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                  ),
                ),
                const SizedBox(width: 8),
                _WeekButton(
                  icon: Icons.chevron_right_rounded,
                  onTap: () => pageController.nextPage(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 340,
          child: PageView.builder(
            controller: pageController,
            onPageChanged: onPageChanged,
            itemBuilder: (context, index) {
              final month = monthForPage(index);
              return _MonthGrid(
                month: month,
                selectedDate: selectedDate,
                reminderCounts: reminderCounts,
                onDateSelected: onDateSelected,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime month;
  final DateTime selectedDate;
  final Map<String, int> reminderCounts;
  final ValueChanged<DateTime> onDateSelected;

  const _MonthGrid({
    super.key,
    required this.month,
    required this.selectedDate,
    required this.reminderCounts,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final firstDayOfMonth = DateTime(month.year, month.month, 1);
    final leadingOffset = firstDayOfMonth.weekday - 1;
    final gridStart = firstDayOfMonth.subtract(Duration(days: leadingOffset));

    final weeks = List.generate(6, (weekIndex) {
      return List.generate(7, (dayIndex) {
        return gridStart.add(Duration(days: weekIndex * 7 + dayIndex));
      });
    });

    return Column(
      children: [
        Row(
          children: _weekdayLabels().map((label) {
            return Expanded(
              child: Center(
                child: Text(
                  label,
                  style: AppText.medium_12a.copyWith(color: context.colors.gray),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: Column(
            children: List.generate(weeks.length, (weekIndex) {
              final week = weeks[weekIndex];
              return Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: week.map((date) {
                          final inCurrentMonth = date.month == month.month;
                          final selected = _isSameDay(date, selectedDate);
                          final count = reminderCounts[_dateKey(date)] ?? 0;

                          return Expanded(
                            child: _MonthDayCell(
                              date: date,
                              selected: selected,
                              inCurrentMonth: inCurrentMonth,
                              reminderCount: count,
                              onTap: () => onDateSelected(date),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (weekIndex < weeks.length - 1)
                      const SizedBox(height: 6), // ← расстояние между неделями
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  List<String> _weekdayLabels() {
    final monday = DateTime(2024, 1, 1);
    return List.generate(7, (i) {
      final d = monday.add(Duration(days: i));
      return DateFormat('E').format(d).substring(0, 2);
    });
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _dateKey(DateTime date) {
    final local = date.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

class _MonthDayCell extends StatelessWidget {
  final DateTime date;
  final bool selected;
  final bool inCurrentMonth;
  final int reminderCount;
  final VoidCallback onTap;

  const _MonthDayCell({
    required this.date,
    required this.selected,
    required this.inCurrentMonth,
    required this.reminderCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasReminders = reminderCount > 0;
    final badgeText = reminderCount > 9 ? '9+' : reminderCount.toString();
    final baseColor =
        inCurrentMonth ? context.colors.text : context.colors.gray;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: selected
                    ? context.colors.primary
                    : context.colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  date.day.toString(),
                  style: AppText.medium_12a.copyWith(
                    color: selected
                        ? context.colors.bg
                        : baseColor.withValues(alpha: inCurrentMonth ? 1 : 0.4),
                  ),
                ),
              ),
            ),
            if (hasReminders) ...[
              const SizedBox(height: 2),
              Container(
                height: 11,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: selected
                      ? context.colors.primary
                      : context.colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Center(
                  child: Text(
                    badgeText,
                    style: AppText.medium_12a.copyWith(
                      height: 1,
                      color:
                          selected ? context.colors.bg : context.colors.primary,
                    ),
                  ),
                ),
              ),
            ],
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
    final t = AppLocalizations.of(context)!;
    final title = reminder.title.isEmpty ? t.notesTabReminders : reminder.title;
    final isPast = reminder.remindAt.toLocal().isBefore(DateTime.now());

    return Opacity(
      opacity: isPast ? 0.55 : 1,
      child: Row(
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
              isPast ? Icons.check_rounded : Icons.notifications_none_rounded,
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
                  title,
                  style:
                      AppText.medium_14a.copyWith(color: context.colors.text),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('MMM d, h:mm a')
                      .format(reminder.remindAt.toLocal()),
                  style:
                      AppText.medium_12a.copyWith(color: context.colors.gray),
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
              _timeLabel(context, reminder.remindAt),
              style: AppText.medium_12a.copyWith(color: context.colors.gray),
            ),
          ),
        ],
      ),
    );
  }

  String _timeLabel(BuildContext context, DateTime value) {
    final t = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final local = value.toLocal();
    final diff = local.difference(now);

    if (diff.inMinutes <= 0) {
      final daysAgo = now.difference(local).inDays;
      if (daysAgo < 1) return t.timeNow;
      return DateFormat('MMM d').format(local);
    }

    if (diff.inHours < 1) return t.timeInMinutes(diff.inMinutes);
    if (diff.inDays < 1) return t.timeInHours(diff.inHours);

    return t.timeInDays(diff.inDays);
  }
}
