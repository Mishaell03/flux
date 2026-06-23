import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/scroll.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/l10n/app_localizations.dart';

const double _kMaxContentWidth = 560;

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.bg,
      body: AppVerticalScroll(
        paddingH: 20,
        paddingV: 0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _kMaxContentWidth),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    t.profileTitle,
                    style: AppText.bold_24.copyWith(color: context.colors.text),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.settings_outlined, color: context.colors.text, size: 26),
                  ),
                ],
              ),
              _ProfileCard(),
              const SizedBox(height: 16),
              _SyncCard(),
              const SizedBox(height: 16),
              _StatsCard(),
              const SizedBox(height: 16),
              _SettingsList(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── User profile card ───────────────────────────────────────────────────────

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return _Card(
      child: Row(
        children: [
          // Avatar — фиксированный размер, не сжимается
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: context.colors.bg,
            ),
            clipBehavior: Clip.antiAlias,
            child: Icon(Icons.person_rounded, size: 40, color: context.colors.gray),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  t.profileNamePlaceholder,
                  style: AppText.medium_18a.copyWith(color: context.colors.text),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  t.profileEmailPlaceholder,
                  style: AppText.light_14a.copyWith(color: context.colors.gray),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                // Бейдж не растягивается — ограничиваем через Row + min
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: context.colors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 18,
                              height: 18,
                              decoration: BoxDecoration(
                                color: context.colors.yandex,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Image.asset('assets/img/yandex.png'),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                t.profileYandexConnected,
                                style: AppText.medium_12a.copyWith(color: context.colors.primary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(Icons.check_circle_rounded, size: 16, color: context.colors.primary),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Sync status card ────────────────────────────────────────────────────────

class _SyncCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cloud_outlined, color: context.colors.primary, size: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.profileSyncStatus,
                      style: AppText.medium_15a.copyWith(color: context.colors.text),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      t.profileSyncUpToDate,
                      style: AppText.light_14a.copyWith(color: context.colors.gray),
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
              Expanded(child: _SyncChip(icon: Icons.check_circle_outline_rounded, label: t.profileSyncLocal, value: t.profileSyncSynced, color: context.colors.success)),
              Expanded(child: _SyncChip(icon: Icons.check_circle_outline_rounded, label: t.profileSyncCloud, value: t.profileSyncSynced, color: context.colors.success)),
              Expanded(child: _SyncChip(icon: Icons.access_time_rounded, label: t.profileSyncLastSync, value: t.profileSyncLastSyncValue, color: context.colors.gray)),
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

// ─── Stats card ──────────────────────────────────────────────────────────────

class _StatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return _Card(
      child: Row(
        children: [
          Expanded(child: _StatItem(icon: Icons.calendar_month_outlined, iconColor: context.colors.primary, count: '—', label: t.profileStatNotes)),
          _VerticalDivider(),
          Expanded(child: _StatItem(icon: Icons.notifications_outlined, iconColor: context.colors.warning, count: '—', label: t.profileStatReminders)),
          _VerticalDivider(),
          Expanded(child: _StatItem(icon: Icons.link_rounded, iconColor: context.colors.primary, count: '—', label: t.profileStatLinked)),
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
          child: Icon(icon, color: iconColor, size: 22),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: AppText.bold_24.copyWith(color: context.colors.text),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppText.medium_12a.copyWith(color: context.colors.gray),
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

// ─── Settings list ───────────────────────────────────────────────────────────

class _SettingsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return _Card(
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
            value: t.profileSettingsDevicesValue,
            onTap: () {},
          ),
          _ItemDivider(),
          _SettingsItem(
            icon: Icons.info_outline_rounded,
            label: t.profileSettingsAbout,
            value: t.profileSettingsAboutValue,
            onTap: () {},
            isLast: true,
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
            // value не Expanded — пусть занимает сколько нужно, но с ограничением
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
            Icon(Icons.chevron_right_rounded, color: context.colors.gray, size: 20),
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


class _Card extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _Card({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.colors.border,
        borderRadius: BorderRadius.circular(20),
      ),
      child: child,
    );
  }
}