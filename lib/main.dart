import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_provider.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_screen.dart';
import 'package:reddit_moderator_toolset/features/home/home_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
  ],
  refreshListenable: ValueNotifier<bool>(true),
  redirect: (context, state) {
    final ref = ProviderScope.containerOf(context).read(authStateProvider);

    if (ref.asData?.value == null) {
      return '/auth';
    }
    return null;
  },
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Reddit Moderator Toolset',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

