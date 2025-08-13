import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:reddit_moderator_toolset/data/reddit_api/modmail_repository.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_provider.dart';

void main() {
  test('modmail inbox returns conversations list', () async {
    final mockClient = MockClient((req) async {
      return http.Response(
        json.encode({
          'conversations': {
            't1_x': {'subject': 'Subject X'},
            't1_y': {'subject': 'Subject Y'},
          },
        }),
        200,
        headers: {'content-type': 'application/json'},
      );
    });

    final container = ProviderContainer(
      overrides: [
        authStateProvider.overrideWith((ref) async => 'token'),
        modmailClientProvider.overrideWith(
          (ref) => ModmailClient(httpClient: mockClient),
        ),
      ],
    );
    addTearDown(container.dispose);

    final result = await container.read(modmailInboxProvider.future);
    expect(result.length, 2);
    expect(result.first['subject'], 'Subject X');
  });
}
