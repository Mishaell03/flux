import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/secure/auth_token_storage.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/core/errors/app_exception.dart';
import 'package:front/core/errors/notyce.dart';
import 'package:front/futures/profile/models/session.dart';
import 'package:front/futures/profile/services/session_service.dart';
import 'package:front/futures/profile/widgets/card.dart';
import 'package:front/l10n/app_localizations.dart';

class ProfileSessionsCard extends StatefulWidget {
  const ProfileSessionsCard({super.key});

  @override
  State<ProfileSessionsCard> createState() => _ProfileSessionsCardState();
}

class _ProfileSessionsCardState extends State<ProfileSessionsCard> {
  final ProfileSessionService _service = const ProfileSessionService();

  late Future<List<ProfileSession>> _future;
  int? _revokingSessionId;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<ProfileSession>> _load() async {
    final token = await AuthTokenStorage.read();

    if (token == null || token.trim().isEmpty) {
      throw const AppException(code: AppErrorCode.errorProfileFailed);
    }

    return _service.getSessions(token: token);
  }

  Future<void> _refresh() async {
    setState(() {
      _future = _load();
    });

    await _future;
  }

  Future<void> _revoke(ProfileSession session) async {
    final t = AppLocalizations.of(context)!;
    final token = await AuthTokenStorage.read();

    if (token == null || token.trim().isEmpty) {
      throw const AppException(code: AppErrorCode.errorProfileFailed);
    }

    setState(() {
      _revokingSessionId = session.id;
    });

    try {
      await _service.revokeSession(
        token: token,
        sessionId: session.id,
      );
      await _refresh();
    } catch (error) {
      if (!mounted) return;

      AppNotice.error(
        context,
        message: t.profileSessionRevokeError,
      );
    } finally {
      if (mounted) {
        setState(() {
          _revokingSessionId = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return ProfileCard(
      padding: EdgeInsets.zero,
      child: FutureBuilder<List<ProfileSession>>(
        future: _future,
        builder: (context, snapshot) {
          final sessions = snapshot.data ?? const <ProfileSession>[];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                child: Row(
                  children: [
                    Icon(
                      Icons.devices_outlined,
                      color: context.colors.text,
                      size: 22,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        t.profileSessionsTitle,
                        style: AppText.medium_16a.copyWith(
                          color: context.colors.text,
                        ),
                      ),
                    ),
                    if (snapshot.connectionState == ConnectionState.waiting)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      IconButton(
                        tooltip: t.profileSessionsRefreshTooltip,
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh_rounded),
                      ),
                  ],
                ),
              ),
              if (snapshot.hasError)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                  child: Text(
                    t.profileSessionsLoadError,
                    style: AppText.medium_14a.copyWith(
                      color: context.colors.gray,
                    ),
                  ),
                )
              else if (sessions.isEmpty &&
                  snapshot.connectionState != ConnectionState.waiting)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                  child: Text(
                    t.profileSessionsEmpty,
                    style: AppText.medium_14a.copyWith(
                      color: context.colors.gray,
                    ),
                  ),
                )
              else
                ...sessions.map((session) {
                  final isLast = session == sessions.last;

                  return _SessionTile(
                    session: session,
                    isLast: isLast,
                    isRevoking: _revokingSessionId == session.id,
                    onRevoke: session.isCurrent ? null : () => _revoke(session),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}

class _SessionTile extends StatelessWidget {
  final ProfileSession session;
  final bool isLast;
  final bool isRevoking;
  final VoidCallback? onRevoke;

  const _SessionTile({
    required this.session,
    required this.isLast,
    required this.isRevoking,
    required this.onRevoke,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final title = session.deviceName?.trim().isNotEmpty == true
        ? session.deviceName!.trim()
        : session.platform?.trim().isNotEmpty == true
            ? session.platform!.trim()
            : t.profileSessionDeviceFallback;

    final details = [
      if (session.platform?.trim().isNotEmpty == true) session.platform!.trim(),
      if (session.appVersion?.trim().isNotEmpty == true)
        'v${session.appVersion!.trim()}',
      if (session.provider?.trim().isNotEmpty == true) session.provider!.trim(),
    ].join(' · ');

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
          child: Row(
            children: [
              Icon(
                session.isCurrent
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: session.isCurrent
                    ? context.colors.primary
                    : context.colors.gray,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: AppText.medium_15a.copyWith(
                              color: context.colors.text,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (session.isCurrent)
                          Text(
                            t.profileSessionCurrent,
                            style: AppText.medium_12a.copyWith(
                              color: context.colors.primary,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      details.isEmpty ? session.deviceId : details,
                      style: AppText.medium_12a.copyWith(
                        color: context.colors.gray,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (onRevoke != null)
                IconButton(
                  tooltip: t.profileSessionRevokeTooltip,
                  onPressed: isRevoking ? null : onRevoke,
                  icon: isRevoking
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.logout_rounded),
                ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: context.colors.bg,
            indent: 56,
          ),
      ],
    );
  }
}
