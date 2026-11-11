import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../banking_controller.dart';

class CardsPage extends ConsumerWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cards = ref.watch(ledgerProvider).cards;
    return Scaffold(
      appBar: AppBar(title: const Text('Virtual cards')),
      body: cards.isEmpty
          ? const Center(child: Text('No cards in this demo.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return Card(
                  child: ListTile(
                    title: Text(card.preview),
                    subtitle: Text(
                      '${card.network} · exp ${card.expiry}\nFull card numbers are never stored.',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
