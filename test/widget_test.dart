import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import ProviderScope

import 'package:reddit_moderator_toolset/main.dart';

void main() {
  testWidgets('App starts and displays initial screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // Wrap MyApp with ProviderScope to resolve the Riverpod error.
    await tester.pumpWidget(const ProviderScope(child: MyApp()));

    // Since the app redirects based on auth state, we can't directly assert
    // for a specific text without mocking the auth state.
    // For now, we'll just ensure the app builds without crashing.
    // Further tests would involve mocking auth_provider.dart.

    // Example: Verify that MaterialApp.router is present
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}