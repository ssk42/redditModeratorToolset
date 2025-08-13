import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_moderator_toolset/data/reddit_api/reddit_client.dart';
import 'package:reddit_moderator_toolset/features/auth/auth_provider.dart';

final redditClientProvider = Provider<RedditClient>((ref) => RedditClient());

final modqueueProvider = FutureProvider.autoDispose<List<Map<String, dynamic>>>(
  (ref) async {
    final token = await ref.watch(authStateProvider.future);
    if (token == null) return [];
    final client = ref.watch(redditClientProvider);
    return client.fetchModqueue(accessToken: token);
  },
);
