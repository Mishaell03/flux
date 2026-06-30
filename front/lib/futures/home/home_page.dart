import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front/core/components/scroll.dart';
import 'package:front/core/errors/app_exception.dart';
import 'package:front/core/errors/notyce.dart';
import 'package:front/core/sync/sync_service_provider.dart';
import 'package:front/futures/home/models/home_dashboard.dart';
import 'package:front/futures/home/repository/home_repository.dart';
import 'package:front/futures/home/widgets/calendar.dart';
import 'package:front/futures/home/widgets/map.dart';
import 'package:front/futures/home/widgets/notes.dart';
import 'package:front/futures/home/widgets/search.dart';
import 'package:front/futures/home/widgets/search_result.dart';
import 'package:front/futures/home/widgets/section_header.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:front/futures/home/models/search.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  final HomeRepository _repository = HomeRepository();

  late DateTime _selectedDate;
  late Stream<HomeDashboardData> _stream;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _selectedDate = _dateOnly(DateTime.now());
    _stream = _repository.watchDashboardDataForDate(_selectedDate);

    unawaited(_sync());
  }

  void _selectDate(DateTime date) {
    final nextDate = _dateOnly(date);

    setState(() {
      _selectedDate = nextDate;
      _stream = _repository.watchDashboardDataForDate(_selectedDate);
    });
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
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

  void _openSearchItem(SearchNoteItem item) {
    if (item.type == SearchItemType.reminder) {
      final noteId = item.noteId;

      if (noteId == null || noteId.isEmpty) return;

      context.goNamed(
        'reminder_edit',
        pathParameters: {'id': noteId},
      );

      return;
    }

    context.goNamed(
      'note_edit',
      pathParameters: {'id': item.id},
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    const double _kMaxContentWidth = 560;

    final isSearching = _searchQuery.trim().isNotEmpty;

    return RefreshIndicator(
      onRefresh: _refresh,
      child: AppVerticalScroll(
        paddingH: 20,
        paddingV: 0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kMaxContentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              HomeSearch(
                controller: _searchController,
                onChanged: _onSearchChanged,
              ),
              const SizedBox(height: 16),
              StreamBuilder<HomeDashboardData>(
                stream: _stream,
                builder: (context, snapshot) {
                  final data = snapshot.data ?? HomeDashboardData.empty();

                  if (isSearching) {
                    return HomeSearchResults(
                      query: _searchQuery,
                      onNoteTap: _openSearchItem,
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HomeCalendar(
                        selectedDate: _selectedDate,
                        allReminders: data.allReminders,
                        onDateSelected: _selectDate,
                      ),
                      const SizedBox(height: 18),
                      HomeSectionHeader(
                        title: t.homeRecentNotes,
                        action: t.homeSeeAll,
                        onTap: () => context.goNamed('notes'),
                      ),
                      const SizedBox(height: 10),
                      HomeNotes(notes: data.recentNotes),
                      const SizedBox(height: 18),
                      HomeMap(
                        linkedNotesCount: data.linkedNotesCount,
                        onTap: () => context.goNamed('graph'),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
