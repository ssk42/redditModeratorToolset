import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_moderator_toolset/data/reddit_api/modqueue_repository.dart';

class ModqueueScreen extends ConsumerWidget {
  const ModqueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modqueue = ref.watch(modqueueProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Mod Queue')),
      body: modqueue.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No items'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final data = items[i]['data'] as Map<String, dynamic>?;
              final title =
                  data?['title']?.toString() ??
                  data?['subject']?.toString() ??
                  'Item';
              return ListTile(title: Text(title));
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
