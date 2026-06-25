import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/secure/app_version_service.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/profile/models/get_info.dart';
import 'package:front/futures/profile/widgets/card.dart';
import 'package:front/l10n/app_localizations.dart';

class ProfileSettingsList extends StatelessWidget {
  final ProfileResponse profile;

  const ProfileSettingsList({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return ProfileCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _SettingsItem(
            icon: Icons.wb_sunny_outlined,
            label: t.profileSettingsTheme,
            value: t.profileSettingsThemeValue,
            onTap: () {},
          ),
          _ItemDivider(),
          _SettingsItem(
            icon: Icons.notifications_outlined,
            label: t.profileSettingsNotifications,
            value: t.profileSettingsNotificationsValue,
            onTap: () {},
          ),
          _ItemDivider(),
          _SettingsItem(
            icon: Icons.devices_outlined,
            label: t.profileSettingsDevices,
            value: profile.sessionsCount.toString(),
            onTap: () {},
          ),
          _ItemDivider(),
          FutureBuilder<String>(
            future: AppVersionService.appVersion(),
            builder: (context, snapshot) {
              final version = snapshot.data ?? '0.0.0';

              return _SettingsItem(
                icon: Icons.info_outline_rounded,
                label: t.profileSettingsAbout,
                value: '${t.profileSettingsAboutValue} $version',
                onTap: () {},
                isLast: true,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isLast;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.vertical(
        bottom: isLast ? const Radius.circular(20) : Radius.zero,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: context.colors.text, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: AppText.medium_15a.copyWith(color: context.colors.text),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 120),
              child: Text(
                value,
                style: AppText.medium_14a.copyWith(color: context.colors.gray),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.chevron_right_rounded,
                color: context.colors.gray, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ItemDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: context.colors.bg, indent: 56);
  }
}
