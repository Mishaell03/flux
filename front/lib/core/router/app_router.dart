import 'package:front/futures/login/login_page.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
          path: '/login',
          name: 'Login',
        builder: (context, state) {
            return const LoginPage();
        }
      )
    ]
);
