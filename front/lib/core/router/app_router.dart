import 'package:flutter/cupertino.dart';
import 'package:front/futures/login/login_page.dart';
import 'package:front/futures/profile/profile_page.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey =
GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (_, __) => LoginPage(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (_, __) => ProfilePage(),
    ),
  ],
);