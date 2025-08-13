import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_moderator_toolset/data/reddit_api/modmail_repository.dart';

class ModmailScreen extends ConsumerWidget {
  const ModmailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inbox = ref.watch(modmailInboxProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Modmail')),
      body: inbox.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No conversations'));
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, i) {
              final m = items[i];
              final subject = (m['subject'] ?? m['id'] ?? 'Conversation')
                  .toString();
              return ListTile(title: Text(subject));
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
