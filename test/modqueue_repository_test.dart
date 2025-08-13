import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:reddit_moderator_toolset/data/reddit_api/modqueue_repository.dart';
import 'package:reddit_moderator_toolset/data/reddit_api/reddit_client.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_provider.dart';

void main() {
  test('modqueue repository returns mapped children', () async {
    final mockClient = MockClient((req) async {
      expect(req.headers['Authorization']?.startsWith('Bearer '), isTrue);
      return http.Response(
        json.encode({
          'data': {
            'children': [
              {
                'data': {'title': 'First'},
              },
              {
                'data': {'title': 'Second'},
              },
            ],
          },
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final container = ProviderContainer(
      overrides: [
        authStateProvider.overrideWith((ref) async => 'token'),
        redditClientProvider.overrideWith(
          (ref) => RedditClient(httpClient: mockClient),
        ),
      ],
    );

    addTearDown(container.dispose);

    final result = await container.read(modqueueProvider.future);
    expect(result.length, 2);
    expect(result.first['data']['title'], 'First');
  });
}
