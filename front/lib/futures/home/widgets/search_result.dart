import 'dart:async';

import 'package:flutter/material.dart';

import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/home/models/search.dart';
import 'package:front/futures/home/service/search.dart';
import 'package:front/l10n/app_localizations.dart';

class HomeSearchResults extends StatefulWidget {
  final String query;
  final void Function(SearchNoteItem note)? onNoteTap;

  const HomeSearchResults({
    super.key,
    required this.query,
    this.onNoteTap,
  });

  @override
  State<HomeSearchResults> createState() => _HomeSearchResultsState();
}

class _HomeSearchResultsState extends State<HomeSearchResults> {
  Timer? _debounce;

  bool _loading = false;
  String? _error;
  List<SearchNoteItem> _results = [];

  int _requestVersion = 0;
  String _activeQuery = '';

  @override
  void initState() {
    super.initState();
    _scheduleSearch(widget.query, rebuild: false);
  }

  @override
  void didUpdateWidget(covariant HomeSearchResults oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.query != widget.query) {
      _scheduleSearch(widget.query);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _requestVersion++;
    super.dispose();
  }

  void _scheduleSearch(String query, {bool rebuild = true}) {
    _debounce?.cancel();

    final trimmed = query.trim();
    final version = ++_requestVersion;
    _activeQuery = trimmed;

    void updateState() {
      if (trimmed.isEmpty) {
        _results = [];
        _error = null;
        _loading = false;
      } else {
        _error = null;
        _loading = true;
      }
    }

    if (rebuild && mounted) {
      setState(updateState);
    } else {
      updateState();
    }

    if (trimmed.isEmpty) return;

    _debounce = Timer(const Duration(milliseconds: 350), () {
      _runSearch(trimmed, version);
    });
  }

  Future<void> _runSearch(String query, int version) async {
    try {
      final response = await SearchService.search(query: query);

      if (!mounted || version != _requestVersion || query != _activeQuery) {
        return;
      }

      setState(() {
        _results = response.notes;
        _error = null;
        _loading = false;
      });
    } catch (error, stackTrace) {
      debugPrint('Search error: $error');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted || version != _requestVersion || query != _activeQuery) {
        return;
      }

      setState(() {
        _error = AppLocalizations.of(context)!.searchError;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final query = widget.query.trim();

    if (query.isEmpty) {
      return const SizedBox.shrink();
    }

    if (_loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: CircularProgressIndicator(
            color: context.colors.primary,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    if (_error != null) {
      return _Message(
        icon: Icons.error_outline_rounded,
        text: _error!,
      );
    }

    if (_results.isEmpty) {
      return _Message(
        icon: Icons.search_off_rounded,
        text: t.searchEmpty(query),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int i = 0; i < _results.length; i++) ...[
          if (i > 0) const SizedBox(height: 10),
          _ResultCard(
            note: _results[i],
            query: query,
            onTap: widget.onNoteTap == null
                ? null
                : () => widget.onNoteTap!(_results[i]),
          ),
        ],
      ],
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Message({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: context.colors.gray),
            const SizedBox(height: 10),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppText.medium_14a.copyWith(
                color: context.colors.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final SearchNoteItem note;
  final String query;
  final VoidCallback? onTap;

  const _ResultCard({
    required this.note,
    required this.query,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final title = note.title?.trim();
    final description = note.description?.trim();

    final isReminder = note.type == SearchItemType.reminder;

    final icon = isReminder ? Icons.notifications_active_rounded : Icons.notes_rounded;

    final typeText = isReminder ? t.note : t.reminder;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: context.colors.border,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: context.colors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HighlightedText(
                      text: title == null || title.isEmpty
                          ? t.noteUntitled
                          : title,
                      query: query,
                      style: AppText.bold_19.copyWith(
                        color: context.colors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: context.colors.primary.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        typeText,
                        style: AppText.medium_14a.copyWith(
                          color: context.colors.primary,
                        ),
                      ),
                    ),
                    if (description != null && description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      _HighlightedText(
                        text: description,
                        query: query,
                        style: AppText.medium_14a.copyWith(
                          color: context.colors.gray,
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ],
                ),
              ),
              if (onTap != null)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 20,
                  color: context.colors.gray,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HighlightedText extends StatelessWidget {
  final String text;
  final String query;
  final TextStyle style;
  final int? maxLines;

  const _HighlightedText({
    required this.text,
    required this.query,
    required this.style,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = trimmedQuery.toLowerCase();
    final spans = <TextSpan>[];

    int start = 0;

    while (true) {
      final index = lowerText.indexOf(lowerQuery, start);

      if (index < 0) {
        spans.add(TextSpan(text: text.substring(start)));
        break;
      }

      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }

      spans.add(
        TextSpan(
          text: text.substring(index, index + trimmedQuery.length),
          style: style.copyWith(
            color: context.colors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
      );

      start = index + trimmedQuery.length;
    }

    return RichText(
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        style: style,
        children: spans,
      ),
    );
  }
}
