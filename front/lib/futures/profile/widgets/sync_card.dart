import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/core/errors/app_exception.dart';
import 'package:front/core/errors/notyce.dart';
import 'package:front/core/sync/sync_service_provider.dart';
import 'package:front/futures/profile/models/local_sync_status.dart';
import 'package:front/futures/profile/services/local_sync_status_service.dart';
import 'package:front/futures/profile/widgets/card.dart';
import 'package:front/l10n/app_localizations.dart';

class ProfileSyncCard extends StatefulWidget {
  const ProfileSyncCard({super.key});

  @override
  State<ProfileSyncCard> createState() => _ProfileSyncCardState();
}

class _ProfileSyncCardState extends State<ProfileSyncCard> {
  bool _isSyncing = false;

  final LocalSyncStatusService _service = LocalSyncStatusService();

  Future<void> _sync() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      await SyncServiceProvider.instance.sync();
    } on AppException catch (error) {
      if (!mounted) return;

      AppNotice.error(
        context,
        message: error.code.localizedMessage(context),
      );
    } catch (_) {
      if (!mounted) return;

      AppNotice.error(
        context,
        message: AppLocalizations.of(context)!.homeSyncError,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<LocalSyncStatus>(
      stream: _service.watch(),
      initialData: const LocalSyncStatus.empty(),
      builder: (context, snapshot) {
        final status = snapshot.data ?? const LocalSyncStatus.empty();
        final hasPending = status.hasPendingChanges;
        final statusColor =
            hasPending ? context.colors.warning : context.colors.success;
        final statusIcon =
            hasPending ? Icons.sync_problem_rounded : Icons.cloud_done_outlined;

        return _SyncCardContent(
          status: status,
          statusColor: statusColor,
          statusIcon: statusIcon,
          isSyncing: _isSyncing,
          onSync: _sync,
        );
      },
    );
  }
}

class _SyncCardContent extends StatelessWidget {
  final LocalSyncStatus status;
  final Color statusColor;
  final IconData statusIcon;
  final bool isSyncing;
  final VoidCallback onSync;

  const _SyncCardContent({
    required this.status,
    required this.statusColor,
    required this.statusIcon,
    required this.isSyncing,
    required this.onSync,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final hasPending = status.hasPendingChanges;

    return ProfileCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                statusIcon,
                color: statusColor,
                size: 26,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.profileSyncStatus,
                      style: AppText.medium_15a.copyWith(
                        color: context.colors.text,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      hasPending ? t.profileSyncPending : t.profileSyncUpToDate,
                      style: AppText.light_14a.copyWith(
                        color: context.colors.gray,
                      ),
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
                  icon: Icons.storage_rounded,
                  label: t.profileSyncLocal,
                  value: status.localItemsCount.toString(),
                  color: context.colors.primary,
                ),
              ),
              Expanded(
                child: _SyncChip(
                  icon: hasPending
                      ? Icons.cloud_upload_outlined
                      : Icons.check_circle_outline_rounded,
                  label: t.profileSyncCloud,
                  value: hasPending
                      ? t.profileSyncPendingShort
                      : t.profileSyncSynced,
                  color: hasPending
                      ? context.colors.warning
                      : context.colors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: isSyncing ? null : onSync,
              style: TextButton.styleFrom(
                backgroundColor: context.colors.primary,
                disabledBackgroundColor:
                    context.colors.primary.withValues(alpha: 0.5),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              icon: isSyncing
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: context.colors.bg,
                      ),
                    )
                  : Icon(
                      Icons.sync_rounded,
                      color: context.colors.bg,
                      size: 20,
                    ),
              label: Text(
                isSyncing ? t.profileSyncing : t.profileSyncAction,
                style: AppText.medium_14a.copyWith(
                  color: context.colors.bg,
                ),
              ),
            ),
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
