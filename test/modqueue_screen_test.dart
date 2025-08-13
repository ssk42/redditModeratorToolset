import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:reddit_moderator_toolset/data/reddit_api/modqueue_repository.dart';
import 'package:reddit_moderator_toolset/data/reddit_api/reddit_client.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_provider.dart';
import 'package:reddit_moderator_toolset/features/modqueue/modqueue_screen.dart';

void main() {
  testWidgets('renders titles from modqueue', (tester) async {
    final mockClient = MockClient((req) async {
      return http.Response(
        json.encode({
          'data': {
            'children': [
              {
                'data': {'title': 'Item A'},
              },
              {
                'data': {'title': 'Item B'},
              },
            ],
          },
        }),
        200,
      );
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWith((ref) async => 'token'),
          redditClientProvider.overrideWith(
            (ref) => RedditClient(httpClient: mockClient),
          ),
        ],
        child: const MaterialApp(home: ModqueueScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Item A'), findsOneWidget);
    expect(find.text('Item B'), findsOneWidget);
  });
}
