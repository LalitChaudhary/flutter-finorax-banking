import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../banking_controller.dart';

class ActivityPage extends ConsumerWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notices = ref.watch(ledgerProvider).notices;
    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: notices.isEmpty
          ? const Center(child: Text('You are caught up.'))
          : ListView.builder(
              itemCount: notices.length,
              itemBuilder: (context, index) {
                final notice = notices[index];
                return ListTile(
                  title: Text(notice.title),
                  subtitle: Text(notice.body),
                  trailing: notice.read
                      ? const Icon(Icons.drafts_outlined)
                      : IconButton(
                          tooltip: 'Mark read',
                          icon: const Icon(Icons.mark_email_unread_outlined),
                          onPressed: () => ref
                              .read(ledgerProvider.notifier)
                              .markRead(notice.id),
                        ),
                );
              },
            ),
    );
  }
}
