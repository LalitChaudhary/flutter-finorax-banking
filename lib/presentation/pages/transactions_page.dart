import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities.dart';
import '../banking_controller.dart';
import '../widgets/common.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledger = ref.watch(ledgerProvider);
    final controller = ref.read(ledgerProvider.notifier);
    final items = controller.visible;
    final categories =
        ledger.transactions.map((e) => e.category).toSet().toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Transactions')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                controller.setQuery(TxQuery(
                  accountId: ledger.query.accountId,
                  category: ledger.query.category,
                  direction: ledger.query.direction,
                  search: value,
                ));
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('All'),
                  selected: ledger.query.category == null,
                  onSelected: (_) =>
                      controller.setQuery(TxQuery(search: ledger.query.search)),
                ),
                const SizedBox(width: 8),
                ...categories.map(
                  (category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: ledger.query.category == category,
                      onSelected: (_) => controller.setQuery(
                        TxQuery(
                            category: category, search: ledger.query.search),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const EmptyHint('Nothing matches these filters.')
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final tx = items[index];
                      final sign =
                          tx.direction == TxDirection.credit ? '+' : '−';
                      return ListTile(
                        title: Text(tx.title),
                        subtitle: Text(
                            '${tx.category}${tx.pending ? ' · pending' : ''}'),
                        trailing: Text('$sign${tx.amount.format()}'),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Page ${ledger.query.page}'),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Previous page',
                      onPressed: ledger.query.page <= 1
                          ? null
                          : () => controller.setQuery(TxQuery(
                                accountId: ledger.query.accountId,
                                category: ledger.query.category,
                                direction: ledger.query.direction,
                                search: ledger.query.search,
                                page: ledger.query.page - 1,
                              )),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    IconButton(
                      tooltip: 'Next page',
                      onPressed: ledger.query.page * ledger.query.pageSize >=
                              controller.totalFiltered
                          ? null
                          : () => controller.setQuery(TxQuery(
                                accountId: ledger.query.accountId,
                                category: ledger.query.category,
                                direction: ledger.query.direction,
                                search: ledger.query.search,
                                page: ledger.query.page + 1,
                              )),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
