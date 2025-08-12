import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_provider.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_service.dart';
import 'package:reddit_moderator_toolset/main.dart';

class _AuthServiceSpy extends AuthService {
  int signOutCalls = 0;
  _AuthServiceSpy();
  @override
  Future<void> signOut() async {
    signOutCalls++;
  }
}

void main() {
  testWidgets('tapping logout triggers signOut', (tester) async {
    final spy = _AuthServiceSpy();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) async => 'token'),
          authServiceProvider.overrideWith((ref) => spy),
        ],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.logout), findsOneWidget);
    await tester.tap(find.byIcon(Icons.logout));
    await tester.pump();
    expect(spy.signOutCalls, 1);
  });
}
