import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/profile/widgets/card.dart';
import 'package:front/l10n/app_localizations.dart';

class ProfileSyncCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return ProfileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cloud_outlined,
                  color: context.colors.primary, size: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.profileSyncStatus,
                      style: AppText.medium_15a
                          .copyWith(color: context.colors.text),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      t.profileSyncUpToDate,
                      style: AppText.light_14a
                          .copyWith(color: context.colors.gray),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: _SyncChip(
                      icon: Icons.check_circle_outline_rounded,
                      label: t.profileSyncLocal,
                      value: t.profileSyncSynced,
                      color: context.colors.success)),
              Expanded(
                  child: _SyncChip(
                      icon: Icons.check_circle_outline_rounded,
                      label: t.profileSyncCloud,
                      value: t.profileSyncSynced,
                      color: context.colors.success)),
              Expanded(
                  child: _SyncChip(
                      icon: Icons.access_time_rounded,
                      label: t.profileSyncLastSync,
                      value: t.profileSyncLastSyncValue,
                      color: context.colors.gray)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SyncChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _SyncChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppText.medium_12a.copyWith(color: context.colors.text),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(
          value,
          style: AppText.medium_12a.copyWith(color: context.colors.gray),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
