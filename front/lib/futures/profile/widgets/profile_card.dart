import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/profile/models/get_info.dart';
import 'package:front/futures/profile/widgets/card.dart';
import 'package:front/l10n/app_localizations.dart';

class ProfileUserCard extends StatelessWidget {
  final ProfileResponse profile;

  const ProfileUserCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    final name = (profile.name?.trim().isNotEmpty ?? false)
        ? profile.name!
        : t.profileNamePlaceholder;

    final email = (profile.email?.trim().isNotEmpty ?? false)
        ? profile.email!
        : t.profileEmailPlaceholder;

    final provider = profile.sessionProvider ?? 'ya';
    final isYandex = provider == 'ya' || provider == 'yandex';

    return ProfileCard(
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: context.colors.bg,
            ),
            clipBehavior: Clip.antiAlias,
            child: (profile.image != null && profile.image!.isNotEmpty)
                ? Image.network(
                    profile.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) {
                      return Icon(
                        Icons.person_rounded,
                        size: 40,
                        color: context.colors.gray,
                      );
                    },
                  )
                : Icon(
                    Icons.person_rounded,
                    size: 40,
                    color: context.colors.gray,
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppText.medium_18a.copyWith(
                    color: context.colors.text,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  email,
                  style: AppText.light_14a.copyWith(
                    color: context.colors.gray,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
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
                                color: isYandex
                                    ? context.colors.yandex
                                    : context.colors.vk,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Image.asset(
                                  isYandex
                                      ? 'assets/img/yandex.png'
                                      : 'assets/img/vk.png',
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                isYandex
                                    ? t.profileYandexConnected
                                    : t.profileVkConnected,
                                style: AppText.medium_12a.copyWith(
                                  color: context.colors.primary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (profile.isVerified) ...[
                              const SizedBox(width: 6),
                              Icon(
                                Icons.check_circle_rounded,
                                size: 16,
                                color: context.colors.primary,
                              ),
                            ],
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
