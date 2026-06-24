import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:front/core/api/api_config.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/scroll.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/core/errors/app_exception.dart';
import 'package:front/core/errors/notyce.dart';
import 'package:front/core/router/url_launcher.dart';
import 'package:front/core/widgets/animation_button.dart';
import 'package:front/futures/login/auth_callback_waiting_page.dart';
import 'package:front/futures/login/services/get_link.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:universal_io/io.dart';

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
                  Text(
                    t.appTitle,
                    textAlign: TextAlign.center,
                    style: AppText.bold_48.copyWith(
                      color: context.colors.text,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    t.loginWelcome,
                    textAlign: TextAlign.center,
                    style: AppText.medium_14a.copyWith(
                      color: context.colors.text,
                    ),
                  ),
                  SizedBox(height: isCompactHeight ? 34 : 48),
                  const _SignInCard(),
                  SizedBox(height: isCompactHeight ? 32 : 46),
                  Text.rich(
                    TextSpan(
                      text: t.loginContinueYou,
                      style: AppText.medium_12a.copyWith(
                        color: context.colors.gray,
                      ),
                      children: [
                        TextSpan(
                          text: t.loginTermsOfService,
                          style: AppText.medium_12a.copyWith(
                            color: context.colors.primary,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              UrlLauncher.openExternalUrl(
                                'https://disk.yandex.ru/d/iyGDpyKOOz-J2Q',
                              );
                            },
                        ),
                        TextSpan(
                          text: t.loginAnd,
                          style: AppText.medium_12a.copyWith(
                            color: context.colors.gray,
                          ),
                        ),
                        TextSpan(
                          text: t.loginPrivacyPolicy,
                          style: AppText.medium_12a.copyWith(
                            color: context.colors.primary,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              UrlLauncher.openExternalUrl(
                                'https://disk.yandex.ru/d/iyGDpyKOOz-J2Q',
                              );
                            },
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _AuthProvider {
  yandex,
  vk,
}

class _SignInCard extends StatefulWidget {
  const _SignInCard();

  @override
  State<_SignInCard> createState() => _SignInCardState();
}

class _SignInCardState extends State<_SignInCard> {
  _AuthProvider? _loadingProvider;

  bool get _isLoading => _loadingProvider != null;

  Future<void> _runWithLoading(
    _AuthProvider provider,
    Future<void> Function() action,
  ) async {
    if (_isLoading) return;

    setState(() {
      _loadingProvider = provider;
    });

    try {
      await action();
    } catch (e) {
      debugPrint('caught: $e');
    } finally {
      if (!mounted) return;

      setState(() {
        _loadingProvider = null;
      });
    }
  }

  Future<void> _getLink(
      BuildContext context, {
        required String url,
      }) async {
    final t = AppLocalizations.of(context)!;

    try {
      final response = await GetLinkService.getLink(
        url: url,
        platform: _platform,
        language: Localizations.localeOf(context).languageCode,
      );

      if (!context.mounted) return;

      final isCompleted = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => AuthCallbackWaitingPage(
            authUrl: response.url,
          ),
        ),
      );

      if (isCompleted == true && context.mounted) {
        context.goNamed('profile');
      }
    } on AppException catch (error) {
      if (!context.mounted) return;

      AppNotice.error(
        context,
        message: error.code.localizedMessage(context),
      );
    } catch (_) {
      if (!context.mounted) return;

      AppNotice.error(
        context,
        message: t.errorAuthFailed,
      );
    }
  }

  String get _platform {
    if (kIsWeb) return 'web';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isWindows) return 'windows';
    if (Platform.isMacOS) return 'macos';

    return 'linux';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final isCompactHeight = size.width < 500;
    final t = AppLocalizations.of(context)!;

    return IgnorePointer(
      ignoring: _isLoading,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 180),
        opacity: _isLoading ? 0.85 : 1,
        child: Container(
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
              Text(
                t.loginCreateAccount,
                textAlign: TextAlign.center,
                style: AppText.medium_24a,
              ),
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
                  height: isCompactHeight ? 50 : 54,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: _loadingProvider == _AuthProvider.yandex
                        ? const Center(
                            key: ValueKey('yandex_loader'),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                              ),
                            ),
                          )
                        : Row(
                            key: const ValueKey('yandex_content'),
                            children: [
                              Image.asset(
                                'assets/img/yandex.png',
                                width: isCompactHeight ? 38 : 42,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  t.loginWithYandex,
                                  style: AppText.medium_14a,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                onPressed: () {
                  _runWithLoading(
                    _AuthProvider.yandex,
                    () => _getLink(
                      context,
                      url: ApiConfig.yandexLogin,
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              AppAnimationButton(
                color: context.colors.vk,
                borderRadius: 20,
                child: Container(
                  height: isCompactHeight ? 50 : 54,
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: _loadingProvider == _AuthProvider.vk
                        ? const Center(
                            key: ValueKey('vk_loader'),
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                              ),
                            ),
                          )
                        : Row(
                            key: const ValueKey('vk_content'),
                            children: [
                              Image.asset(
                                'assets/img/vk.png',
                                width: isCompactHeight ? 38 : 42,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  t.loginWithVk,
                                  style: AppText.medium_14a,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                onPressed: () {
                  // _runWithLoading(
                  //   _AuthProvider.vk,
                  //       () => _getLink(
                  //     context,
                  //     // TODO: исправить на VK ссылку
                  //     url: ApiConfig.yandexLoginUrl,
                  //   ),
                  // );
                  AppNotice.success(context,
                      message: t.sectionDevelopment, title: t.weApologize);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
