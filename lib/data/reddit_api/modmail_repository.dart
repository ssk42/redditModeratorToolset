import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:reddit_moderator_toolset/features/auth/auth_provider.dart';

class ModmailClient {
  ModmailClient({http.Client? httpClient})
    : _http = httpClient ?? http.Client();
  final http.Client _http;

  Future<List<Map<String, dynamic>>> fetchInbox({
    required String accessToken,
  }) async {
    // New modmail v2 endpoint
    final res = await _http.get(
      Uri.parse('https://oauth.reddit.com/api/mod/conversations?limit=25'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'User-Agent': 'modtoolset/0.1',
      },
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch modmail: ${res.statusCode}');
    }
    final body = json.decode(res.body) as Map<String, dynamic>;
    // Minimal normalization: list of conversations; structure simplified for UI
    final convs = (body['conversations'] as Map<String, dynamic>? ?? {});
    return convs.entries
        .map((e) => {'id': e.key, ...(e.value as Map<String, dynamic>)})
        .toList();
  }
}

final modmailClientProvider = Provider<ModmailClient>((ref) => ModmailClient());

final modmailInboxProvider =
    FutureProvider.autoDispose<List<Map<String, dynamic>>>((ref) async {
      final token = await ref.watch(authStateProvider.future);
      if (token == null) return [];
      final client = ref.watch(modmailClientProvider);
      return client.fetchInbox(accessToken: token);
    });
