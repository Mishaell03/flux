import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/profile/models/get_info.dart';
import 'package:front/futures/profile/widgets/card.dart';
import 'package:front/l10n/app_localizations.dart';

class ProfileStatsCard extends StatelessWidget {
  final ProfileResponse profile;

  const ProfileStatsCard({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return ProfileCard(
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.calendar_month_outlined,
              iconColor: context.colors.primary,
              count: profile.notesCount.toString(),
              label: t.profileStatNotes,
            ),
          ),
          _VerticalDivider(),
          Expanded(
            child: _StatItem(
              icon: Icons.notifications_outlined,
              iconColor: context.colors.warning,
              count: profile.remindersCount.toString(),
              label: t.profileStatReminders,
            ),
          ),
          _VerticalDivider(),
          Expanded(
            child: _StatItem(
              icon: Icons.link_rounded,
              iconColor: context.colors.primary,
              count: profile.noteLinksCount.toString(),
              label: t.profileStatLinked,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String count;
  final String label;

  const _StatItem({
    required this.icon,
    required this.iconColor,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 22,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: AppText.bold_24.copyWith(
            color: context.colors.text,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppText.medium_12a.copyWith(
            color: context.colors.gray,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 64,
      color: context.colors.bg,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}