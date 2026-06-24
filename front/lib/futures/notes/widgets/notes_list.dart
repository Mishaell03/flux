import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/notes/models/notes_list_data.dart';
import 'package:front/futures/notes/widgets/notes_card.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class NotesList extends StatelessWidget {
  final List<NoteListItem> notes;
  final ValueChanged<NoteListItem> onTap;

  const NotesList({
    super.key,
    required this.notes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    if (notes.isEmpty) {
      return NotesEmptyState(
        icon: Icons.sticky_note_2_outlined,
        title: t.notesEmptyTitle,
        subtitle: t.notesEmptySubtitle,
      );
    }

    return Column(
      children: List.generate(notes.length, (index) {
        final note = notes[index];
        final isLast = index == notes.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
          child: _NoteTile(
            note: note,
            onTap: () => onTap(note),
          ),
        );
      }),
    );
  }
}

class _NoteTile extends StatelessWidget {
  final NoteListItem note;
  final VoidCallback onTap;

  const _NoteTile({
    required this.note,
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
            icon: Icons.sticky_note_2_outlined,
            color: context.colors.primary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note.title,
                  style: AppText.medium_15a.copyWith(
                    color: context.colors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  note.content,
                  style: AppText.medium_12a.copyWith(
                    color: context.colors.gray,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Text(
                  DateFormat('MMM d, h:mm a').format(note.updatedAt.toLocal()),
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
