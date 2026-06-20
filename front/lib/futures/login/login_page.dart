import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/scroll.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/core/errors/notyce.dart';
import 'package:front/core/router/url_launcher.dart';
import 'package:front/core/widgets/animation_button.dart';
import 'package:front/l10n/app_localizations.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isCompactHeight = size.width < 500;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.bg,
      body: SafeArea(
        child: AppVerticalScroll(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: isCompactHeight ? 8 : 22),
                  Image.asset(
                    'assets/img/login.png',
                    width: isCompactHeight ? 200 : 300,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: isCompactHeight ? 22 : 34),
                  Text(t.appTitle,
                      textAlign: TextAlign.center,
                      style:
                          AppText.bold_48.copyWith(color: context.colors.text)),
                  const SizedBox(height: 18),
                  Text(t.loginWelcome,
                      textAlign: TextAlign.center,
                      style: AppText.medium_14a
                          .copyWith(color: context.colors.text)),
                  SizedBox(height: isCompactHeight ? 34 : 48),
                  _SignInCard(),
                  SizedBox(height: isCompactHeight ? 32 : 46),
                  Text.rich(
                    TextSpan(
                      text: t.loginContinueYou,
                      style: AppText.medium_12a
                          .copyWith(color: context.colors.gray),
                      children: [
                        TextSpan(
                          text: t.loginTermsOfService,
                          style: AppText.medium_12a
                              .copyWith(color: context.colors.primary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              UrlLauncher.openExternalUrl(
                                  'https://disk.yandex.ru/d/iyGDpyKOOz-J2Q');
                            },
                        ),
                        TextSpan(
                            text: t.loginAnd,
                            style: AppText.medium_12a
                                .copyWith(color: context.colors.gray)),
                        TextSpan(
                          text: t.loginPrivacyPolicy,
                          style: AppText.medium_12a
                              .copyWith(color: context.colors.primary),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              UrlLauncher.openExternalUrl(
                                  'https://disk.yandex.ru/d/iyGDpyKOOz-J2Q');
                            },
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SignInCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isCompactHeight = size.width < 500;
    final t = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: context.colors.border,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: context.colors.border),
        boxShadow: [
          BoxShadow(
            color: context.colors.primary.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.colors.primary.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              color: context.colors.primary,
              size: 25,
            ),
          ),
          const SizedBox(height: 22),
          Text(t.loginCreateAccount,
              textAlign: TextAlign.center, style: AppText.medium_24a),
          const SizedBox(height: 9),
          Text(
            t.loginChooseService,
            textAlign: TextAlign.center,
            style: AppText.medium_14a,
          ),
          const SizedBox(height: 28),
          AppAnimationButton(
            color: context.colors.yandex,
            borderRadius: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/img/yandex.png",
                    width: 42,
                  ),
                  SizedBox(width: 10),
                  Text(t.loginWithYandex,
                      style: isCompactHeight
                          ? AppText.medium_12a
                          : AppText.medium_14a)
                ],
              ),
            ),
            onPressed: () async {
              // TODO: vk href
              final isOpened = await UrlLauncher.openExternalUrl('');

              if (!isOpened && context.mounted) {
                AppNotice.error(context, message: t.errorCouldNotOpenLink);
              }
            },
          ),
          const SizedBox(height: 16),
          AppAnimationButton(
            color: context.colors.vk,
            borderRadius: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/img/vk.png",
                    width: 42,
                  ),
                  SizedBox(width: 10),
                  Text(t.loginWithVk,
                      style: isCompactHeight
                          ? AppText.medium_12a
                          : AppText.medium_14a)
                ],
              ),
            ),
            onPressed: () async {
              // TODO: vk href
              final isOpened = await UrlLauncher.openExternalUrl('');

              if (!isOpened && context.mounted) {
                AppNotice.error(context, message: t.errorCouldNotOpenLink);
              }
            },
          )
        ],
      ),
    );
  }
}
