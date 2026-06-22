import 'dart:async';

import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/core/errors/api_exception.dart';
import 'package:front/core/errors/app_exception.dart';
import 'package:front/core/errors/notyce.dart';
import 'package:front/core/widgets/animation_button.dart';
import 'package:front/futures/login/models/auth_deeplink.dart';
import 'package:front/futures/login/services/auth_callback.dart';
import 'package:front/futures/login/services/auth_deeplink.dart';
import 'package:front/l10n/app_localizations.dart';

class AuthCallbackWaitingPage extends StatefulWidget {
  final String authUrl;

  final AuthDeepLinkEventBus? eventBus;
  final AuthExternalAuthService? externalAuthService;
  final AuthCallbackCompleteService? callbackCompleteService;
  final AuthCallbackErrorMapper? errorMapper;

  const AuthCallbackWaitingPage({
    super.key,
    required this.authUrl,
    this.eventBus,
    this.externalAuthService,
    this.callbackCompleteService,
    this.errorMapper,
  });

  @override
  State<AuthCallbackWaitingPage> createState() =>
      _AuthCallbackWaitingPageState();
}

class _AuthCallbackWaitingPageState extends State<AuthCallbackWaitingPage> {
  late final AuthDeepLinkEventBus _eventBus;
  late final AuthExternalAuthService _externalAuthService;
  late final AuthCallbackCompleteService _callbackCompleteService;
  late final AuthCallbackErrorMapper _errorMapper;

  StreamSubscription<AuthDeepLinkData>? _subscription;

  AuthCallbackWaitingState _state =
  const AuthCallbackWaitingState.waiting();

  String? _lastHandledLink;

  @override
  void initState() {
    super.initState();

    _eventBus = widget.eventBus ?? AuthDeepLinkEventBus.instance;
    _externalAuthService =
        widget.externalAuthService ?? const AuthExternalAuthService();
    _callbackCompleteService =
        widget.callbackCompleteService ?? const AuthCallbackCompleteService();
    _errorMapper = widget.errorMapper ?? const AuthCallbackErrorMapper();

    _subscription = _eventBus.stream.listen(
      _handleDeepLinkData,
      onError: (_) {
        _setError();
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pendingData = _eventBus.takePending();

      if (pendingData != null) {
        _handleDeepLinkData(pendingData);
        return;
      }

      _openAuthUrl();
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _openAuthUrl() async {
    final t = AppLocalizations.of(context)!;

    setState(() {
      _state = const AuthCallbackWaitingState.waiting();
    });

    final isOpened = await _externalAuthService.open(widget.authUrl);

    if (!isOpened && mounted) {
      _setError(message: t.errorCouldNotOpenLink);
    }
  }

  Future<void> _handleDeepLinkData(AuthDeepLinkData data) async {
    if (!mounted) return;

    if (_lastHandledLink == data.key) return;
    _lastHandledLink = data.key;

    setState(() {
      _state = const AuthCallbackWaitingState.sending();
    });

    try {
      await _callbackCompleteService.complete(data);

      if (!mounted) return;

      setState(() {
        _state = const AuthCallbackWaitingState.success();
      });

      AppNotice.success(
        context,
        message: AppLocalizations.of(context)!.success,
      );

      Navigator.of(context).pop(true);
    } on ApiException catch (error) {
      if (!mounted) return;

      _setError(message: error.message);
    } on AppException catch (error) {
      if (!mounted) return;

      final t = AppLocalizations.of(context)!;

      _setError(
        message: _errorMapper.fromAppException(error, t),
      );
    } catch (_) {
      if (!mounted) return;

      _setError(
        message: AppLocalizations.of(context)!.errorAuthFailed,
      );
    }
  }

  void _setError({String? message}) {
    if (!mounted) return;

    setState(() {
      _state = AuthCallbackWaitingState.error(
        message ?? AppLocalizations.of(context)!.errorAuthFailed,
      );
    });
  }

  void _goBack() {
    if (!_state.canGoBack) return;

    Navigator.of(context).pop(false);
  }

  String _title(AppLocalizations t) {
    return switch (_state.status) {
      AuthCallbackWaitingStatus.waitingForReturn =>
      t.authCallbackWaitingTitle,
      AuthCallbackWaitingStatus.sendingCallback =>
      t.authCallbackSendingTitle,
      AuthCallbackWaitingStatus.success =>
      t.authCallbackSuccessTitle,
      AuthCallbackWaitingStatus.error =>
      t.authCallbackErrorTitle,
    };
  }

  String _description(AppLocalizations t) {
    return switch (_state.status) {
      AuthCallbackWaitingStatus.waitingForReturn =>
      t.authCallbackWaitingDescription,
      AuthCallbackWaitingStatus.sendingCallback =>
      t.authCallbackSendingDescription,
      AuthCallbackWaitingStatus.success =>
      t.authCallbackSuccessDescription,
      AuthCallbackWaitingStatus.error =>
      _state.errorMessage ?? t.errorAuthFailed,
    };
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: TextButton.icon(
                  onPressed: _state.canGoBack ? _goBack : null,
                  icon: Icon(
                    Icons.arrow_back_rounded,
                    color: _state.canGoBack
                        ? context.colors.text
                        : context.colors.gray,
                  ),
                  label: Text(
                    t.authCallbackBack,
                    style: AppText.medium_14a.copyWith(
                      color: _state.canGoBack
                          ? context.colors.text
                          : context.colors.gray,
                    ),
                  ),
                ),
              ),

              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: context.colors.border,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: context.colors.border,
                      ),
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
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: _state.showLoader
                              ? SizedBox(
                            key: const ValueKey('loader'),
                            width: 54,
                            height: 54,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: context.colors.primary,
                            ),
                          )
                              : Container(
                            key: const ValueKey('icon'),
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: _state.status ==
                                  AuthCallbackWaitingStatus.success
                                  ? context.colors.success.withValues(alpha: 0.18)
                                  : context.colors.error.withValues(alpha: 0.18),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _state.status ==
                                  AuthCallbackWaitingStatus.success
                                  ? Icons.check_rounded
                                  : Icons.close_rounded,
                              color: _state.status ==
                                  AuthCallbackWaitingStatus.success
                                  ? context.colors.success
                                  : context.colors.error,
                              size: 32,
                            ),
                          ),
                        ),

                        const SizedBox(height: 26),

                        Text(
                          _title(t),
                          textAlign: TextAlign.center,
                          style: AppText.medium_24a.copyWith(
                            color: context.colors.text,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          _description(t),
                          textAlign: TextAlign.center,
                          style: AppText.medium_14a.copyWith(
                            color: context.colors.gray,
                          ),
                        ),

                        if (_state.showRetry) ...[
                          const SizedBox(height: 26),
                          AppAnimationButton(
                            color: context.colors.primary,
                            borderRadius: 18,
                            onPressed: _openAuthUrl,
                            child: Container(
                              height: 52,
                              alignment: Alignment.center,
                              padding:
                              const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                t.authCallbackRetry,
                                style: AppText.medium_14a.copyWith(
                                  color: context.colors.text,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}