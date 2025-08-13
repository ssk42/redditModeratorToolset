import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:reddit_moderator_toolset/data/reddit_api/modmail_repository.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_provider.dart';
import 'package:reddit_moderator_toolset/features/modmail/modmail_screen.dart';

void main() {
  testWidgets('renders modmail subjects', (tester) async {
    final mockClient = MockClient((req) async {
      return http.Response(
        json.encode({
          'conversations': {
            't1_x': {'subject': 'Subject X'},
            't1_y': {'subject': 'Subject Y'},
          },
        }),
        200,
      );
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) async => 'token'),
          modmailClientProvider.overrideWith(
            (ref) => ModmailClient(httpClient: mockClient),
          ),
        ],
        child: const MaterialApp(home: ModmailScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Subject X'), findsOneWidget);
    expect(find.text('Subject Y'), findsOneWidget);
  });
}
