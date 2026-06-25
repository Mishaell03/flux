import 'package:flutter/material.dart';
import 'package:front/core/components/app_theme.dart';
import 'package:front/core/components/secure/auth_token_storage.dart';
import 'package:front/core/components/theme.dart';
import 'package:front/futures/loading/services/session_bootstrap_service.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  final SessionBootstrapService _service = const SessionBootstrapService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSession();
    });
  }

  Future<void> _checkSession() async {
    final token = await AuthTokenStorage.read();

    if (!mounted) return;

    if (token == null || token.trim().isEmpty) {
      context.goNamed('login');
      return;
    }

    try {
      final result = await _service.bootstrap(token: token);

      if (result.isSessionNeedUpdate) {
        final refreshed = await _service.refresh(token: token);

        if (refreshed.token.trim().isNotEmpty) {
          await AuthTokenStorage.save(refreshed.token);
        }
      }

      if (mounted) {
        context.goNamed('home');
      }
    } catch (_) {
      await AuthTokenStorage.clear();

      if (mounted) {
        context.goNamed('login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: context.colors.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 52,
              height: 52,
              child: CircularProgressIndicator(
                strokeWidth: 4,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              t.loadingCheckingSession,
              style: AppText.medium_16a.copyWith(
                color: context.colors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
