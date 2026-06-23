import 'package:web/web.dart' as web;
import 'package:front/futures/login/services/auth_callback.dart';
import 'package:front/futures/login/models/auth_deeplink.dart';
import 'package:front/core/router/app_router.dart';
import 'package:flutter/material.dart';

Future<void> handleWebAuthCallback(
    AuthCallbackCompleteService callbackService,
    ) async {
  final href = web.window.location.href;
  final uri = Uri.tryParse(href);
  if (uri == null) return;

  final code = uri.queryParameters['code'];
  final state = uri.queryParameters['state'];

  if (code == null || code.isEmpty || state == null || state.isEmpty) return;

  web.window.history.replaceState(null, '', '/');

  try {
    final data = AuthDeepLinkData(uri: uri, state: state, code: code);
    await callbackService.complete(data);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.goNamed('profile');
    });
  } catch (e) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      router.goNamed('login');
    });
  }
}