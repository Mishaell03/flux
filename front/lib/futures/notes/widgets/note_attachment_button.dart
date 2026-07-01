import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/l10n/app_localizations.dart';

class NoteAttachmentButton extends StatelessWidget {
  final VoidCallback? onAddImage;
  final VoidCallback? onRecordAudio;

  const NoteAttachmentButton({
    super.key,
    this.onAddImage,
    this.onRecordAudio,
  });

  void _showAttachmentSheet(BuildContext context) {
    final colors = context.colors;
    final t = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Container(
                decoration: BoxDecoration(
                  color: colors.bg,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: colors.border,
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 8),
                    Container(
                      width: 38,
                      height: 4,
                      decoration: BoxDecoration(
                        color: colors.gray.withValues(alpha: 0.35),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _AttachmentActionTile(
                      icon: Icons.image_rounded,
                      title: t.noteAttachmentAddImage,
                      subtitle: t.noteAttachmentAddImageDescription,
                      onTap: () {
                        Navigator.pop(context);
                        onAddImage?.call();
                      },
                    ),
                    Divider(
                      height: 1,
                      color: colors.border,
                    ),
                    _AttachmentActionTile(
                      icon: Icons.mic_rounded,
                      title: t.noteAttachmentRecordAudio,
                      subtitle: t.noteAttachmentRecordAudioDescription,
                      onTap: () {
                        Navigator.pop(context);
                        onRecordAudio?.call();
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return IconButton(
      tooltip: t.noteAttachmentTooltip,
      icon: const Icon(Icons.attach_file_rounded),
      onPressed: () => _showAttachmentSheet(context),
    );
  }
}

class _AttachmentActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AttachmentActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                size: 22,
                color: colors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppText.medium_16a.copyWith(
                      color: colors.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: AppText.medium_14a.copyWith(
                      color: colors.gray,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: colors.gray,
            ),
          ],
        ),
      ),
    );
  }
}