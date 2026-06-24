import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/home/models/home_dashboard.dart';
import 'package:front/futures/home/widgets/card.dart';
import 'package:front/futures/home/widgets/empty_line.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class HomeNotes extends StatelessWidget {
  final List<HomeNotePreview> notes;

  const HomeNotes({
    required this.notes,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (notes.isEmpty) {
      return HomeCard(
        child: EmptyLine(
          icon: Icons.sticky_note_2_outlined,
          text: t.homeNoNotes,
        ),
      );
    }

    final visibleNotes = notes.take(2).toList();

    return Row(
      children: visibleNotes.map((note) {
        final isLast = note == visibleNotes.last;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 12),
            child: _NoteCard(note: note),
          ),
        );
      }).toList(),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final HomeNotePreview note;

  const _NoteCard({
    required this.note,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.goNamed('/notes'),
      child: Container(
        height: 154,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: context.colors.border,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: AppText.medium_14a.copyWith(
                color: context.colors.text,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('MMM d').format(note.updatedAt.toLocal()),
              style: AppText.medium_12a.copyWith(
                color: context.colors.gray,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Text(
                note.content,
                style: AppText.light_14a.copyWith(
                  color: context.colors.text,
                  height: 1.25,
                ),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: context.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Note',
                    style: AppText.medium_12a.copyWith(
                      color: context.colors.primary,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.star_border_rounded,
                  color: context.colors.gray,
                  size: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}