import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_provider.dart';
import 'package:reddit_moderator_toolset/main.dart';

void main() {
  testWidgets('redirects to /auth when not logged in', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authStateProvider.overrideWith((ref) async => null)],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Sign In with Reddit'), findsOneWidget);
  });

  testWidgets('stays on home when logged in', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authStateProvider.overrideWith((ref) async => 'token')],
        child: const MyApp(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Welcome!'), findsOneWidget);
  });
}
