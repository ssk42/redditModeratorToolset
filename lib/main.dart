import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reddit_moderator_toolset/core/theme/app_theme.dart';
import 'package:reddit_moderator_toolset/core/routing/go_router_notifier.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_screen.dart';
import 'package:reddit_moderator_toolset/features/home/home_screen.dart';
import 'package:reddit_moderator_toolset/features/modqueue/modqueue_screen.dart';
import 'package:reddit_moderator_toolset/features/modmail/modmail_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

GoRouter _createRouter(WidgetRef ref) {
  final notifier = ref.watch(goRouterNotifierProvider);
  return GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/auth', builder: (context, state) => const AuthScreen()),
      GoRoute(
        path: '/modqueue',
        builder: (context, state) => const ModqueueScreen(),
      ),
      GoRoute(
        path: '/modmail',
        builder: (context, state) => const ModmailScreen(),
      ),
    ],
    refreshListenable: notifier,
    redirect: (context, state) {
      final isAuthed = notifier.isAuthenticated;
      final loggingIn = state.matchedLocation == '/auth';
      if (!isAuthed && !loggingIn) return '/auth';
      if (isAuthed && loggingIn) return '/';
      return null;
    },
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = _createRouter(ref);
    return MaterialApp.router(
      routerConfig: router,
      title: 'Reddit Moderator Toolset',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
    );
  }
}
