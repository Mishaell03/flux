import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:front/core/router/app_router.dart';
import 'package:front/futures/login/services/auth_deeplink.dart';
import 'package:front/futures/login/services/auth_callback.dart';
import 'package:front/l10n/app_localizations.dart';
import 'package:universal_io/io.dart';
import 'package:window_manager/window_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// conditional import — на вебе реальный, на остальных заглушка
import 'package:front/futures/login/services/web_auth_stub.dart' if (dart.library.js_interop) 'package:front/futures/login/services/web_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb &&
      (Platform.isLinux || Platform.isMacOS || Platform.isWindows)) {
    await windowManager.ensureInitialized();

    const windowOptions = WindowOptions(
      size: Size(500, 800),
      minimumSize: Size(360, 500),
      center: true,
      title: 'Flux',
    );

    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  final authCallbackService = AuthCallbackCompleteService();

  if (kIsWeb) {
    await handleWebAuthCallback(authCallbackService);
    runApp(const MyApp());
    return;
  }

  final deepLinkListener = AuthDeepLinkListener(
    router: router,
    navigatorKey: rootNavigatorKey,
    callbackService: authCallbackService,
  );
  await deepLinkListener.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(brightness: Brightness.light, useMaterial3: true),
      darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
    );
  }
}