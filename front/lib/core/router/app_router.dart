import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:front/core/router/app_shell.dart';
import 'package:front/futures/graph/graph_page.dart';
import 'package:front/futures/home/home_page.dart';
import 'package:front/futures/loading/loading_page.dart';
import 'package:front/futures/login/login_page.dart';
import 'package:front/futures/notes/note_editor_page.dart';
import 'package:front/futures/notes/notes_page.dart';
import 'package:front/futures/notes/reminder_editor_page.dart';
import 'package:front/futures/profile/profile_page.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/loading',
  routes: [
    GoRoute(
      path: '/loading',
      name: 'loading',
      builder: (context, state) => const LoadingPage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShell(
          navigationShell: navigationShell,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notes',
              name: 'notes',
              builder: (context, state) => const NotesPage(),
              routes: [
                GoRoute(
                  path: 'new',
                  name: 'note_new',
                  builder: (context, state) => const NoteEditorPage(),
                ),
                GoRoute(
                  path: ':id',
                  name: 'note_edit',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return NoteEditorPage(noteId: id);
                  },
                ),
                GoRoute(
                  path: 'reminder/new',
                  name: 'reminder_new',
                  builder: (context, state) => const ReminderEditorPage(),
                ),
                GoRoute(
                  path: 'reminder/:id',
                  name: 'reminder_edit',
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return ReminderEditorPage(noteId: id);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/graph',
              name: 'graph',
              builder: (context, state) => const GraphPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
