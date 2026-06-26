import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front/core/components/scroll.dart';
import 'package:front/core/errors/app_exception.dart';
import 'package:front/core/errors/notyce.dart';
import 'package:front/core/sync/sync_service_provider.dart';
import 'package:front/futures/home/models/home_dashboard.dart';
import 'package:front/futures/home/repository/home_repository.dart';
import 'package:front/futures/home/widgets/calendar.dart';
import 'package:front/futures/home/widgets/home_header.dart';
import 'package:front/futures/home/widgets/map.dart';
import 'package:front/futures/home/widgets/notes.dart';
import 'package:front/futures/home/widgets/search.dart';
import 'package:front/futures/home/widgets/section_header.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final HomeRepository _repository = HomeRepository();

  late DateTime _selectedDate;
  late DateTime _weekStart;
  late Stream<HomeDashboardData> _stream;

  @override
  void initState() {
    super.initState();

    _selectedDate = _dateOnly(DateTime.now());
    _weekStart = _startOfWeek(_selectedDate);
    _stream = _repository.watchDashboardDataForDate(_selectedDate);

    unawaited(_sync());
  }

  void _selectDate(DateTime date) {
    final nextDate = _dateOnly(date);

    setState(() {
      _selectedDate = nextDate;
      _weekStart = _startOfWeek(nextDate);
      _stream = _repository.watchDashboardDataForDate(_selectedDate);
    });
  }

  void _moveWeek(int offset) {
    final nextDate = _selectedDate.add(Duration(days: offset * 7));

    setState(() {
      _selectedDate = _dateOnly(nextDate);
      _weekStart = _startOfWeek(_selectedDate);
      _stream = _repository.watchDashboardDataForDate(_selectedDate);
    });
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  DateTime _startOfWeek(DateTime value) {
    final date = _dateOnly(value);

    return date.subtract(Duration(days: date.weekday - 1));
  }

  Future<void> _sync() async {
    try {
      await SyncServiceProvider.instance.sync();
    } catch (error) {
      if (!mounted) return;

      if (error is AppException) {
        AppNotice.error(
          context,
          message: error.code.localizedMessage(context),
        );
        return;
      }

      AppNotice.error(
        context,
        message: AppLocalizations.of(context)!.homeSyncError,
      );
    }
  }

  Future<void> _refresh() async {
    await _sync();
  }

  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    const double _kMaxContentWidth = 560;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: AppVerticalScroll(
        paddingH: 20,
        paddingV: 0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kMaxContentWidth),
          child: StreamBuilder<HomeDashboardData>(
            stream: _stream,
            builder: (context, snapshot) {
              final data = snapshot.data ?? HomeDashboardData.empty();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  HomeHeader(),
                  const SizedBox(height: 18),
                  HomeSearch(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    onFilterTap: () {
                      // TODO: фильтр поиска
                    },
                  ),
                  const SizedBox(height: 16),
                  HomeCalendar(
                    selectedDate: _selectedDate,
                    weekStart: _weekStart,
                    reminderDayKeys: data.reminderDayKeys,
                    reminders: data.upcomingReminders,
                    onDateSelected: _selectDate,
                    onPreviousWeek: () => _moveWeek(-1),
                    onNextWeek: () => _moveWeek(1),
                  ),
                  const SizedBox(height: 18),
                  HomeSectionHeader(
                    title: t.homeRecentNotes,
                    action: t.homeSeeAll,
                    onTap: () => context.goNamed('notes'),
                  ),
                  const SizedBox(height: 10),
                  HomeNotes(
                    notes: _filterNotes(data.recentNotes),
                  ),
                  const SizedBox(height: 18),
                  HomeMap(
                    linkedNotesCount: data.linkedNotesCount,
                    onTap: () => context.goNamed('graph'),
                  ),
                  const SizedBox(height: 32),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<HomeNotePreview> _filterNotes(List<HomeNotePreview> notes) {
    final query = _searchQuery.trim().toLowerCase();

    if (query.isEmpty) {
      return notes;
    }

    return notes.where((note) {
      return note.title.toLowerCase().contains(query) ||
          note.content.toLowerCase().contains(query);
    }).toList();
  }
}
