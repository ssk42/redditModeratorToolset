import 'dart:convert';
import 'package:http/http.dart' as http;

class RedditClient {
  RedditClient({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  final http.Client _http;

  Future<List<Map<String, dynamic>>> fetchModqueue({
    required String accessToken,
  }) async {
    final res = await _http.get(
      Uri.parse('https://oauth.reddit.com/r/all/about/modqueue'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'User-Agent': 'modtoolset/0.1',
      },
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch modqueue: ${res.statusCode}');
    }
    final body = json.decode(res.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    final children = (data['children'] as List<dynamic>)
        .cast<Map<String, dynamic>>();
    return children;
  }
}
