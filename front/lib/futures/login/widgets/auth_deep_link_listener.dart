import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:front/futures/login/models/auth_deeplink.dart';
import 'package:front/futures/login/services/auth_deeplink.dart';

class AuthDeepLinkListener extends StatefulWidget {
  final Widget child;

  const AuthDeepLinkListener({
    super.key,
    required this.child,
  });

  @override
  State<AuthDeepLinkListener> createState() => _AuthDeepLinkListenerState();
}

class _AuthDeepLinkListenerState extends State<AuthDeepLinkListener> {
  final AppLinks _appLinks = AppLinks();
  final AuthDeepLinkParser _parser = const AuthDeepLinkParser();
  final AuthDeepLinkEventBus _eventBus = AuthDeepLinkEventBus.instance;

  StreamSubscription<Uri>? _subscription;

  @override
  void initState() {
    super.initState();

    _handleInitialLink();

    _subscription = _appLinks.uriLinkStream.listen(
      _handleLink,
      onError: (_) {},
    );
  }

  Future<void> _handleInitialLink() async {
    try {
      final uri = await _appLinks.getInitialLink();

      if (uri != null) {
        _handleLink(uri);
      }
    } catch (_) {}
  }

  void _handleLink(Uri uri) {
    final AuthDeepLinkData? data = _parser.parse(uri);

    if (data == null) return;

    _eventBus.emit(data);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}