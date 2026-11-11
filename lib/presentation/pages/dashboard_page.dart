import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities.dart';
import '../banking_controller.dart';
import '../widgets/common.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key, this.accountsOnly = false});

  final bool accountsOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledger = ref.watch(ledgerProvider);
    final session = ref.watch(sessionProvider);
    if (ledger.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (ledger.error != null && ledger.accounts.isEmpty) {
      return Scaffold(
          body:
              Center(child: StatusBanner(message: ledger.error!, error: true)));
    }
    final width = MediaQuery.of(context).size.width;
    final cross = width > 900
        ? 3
        : width > 600
            ? 2
            : 1;
    return Scaffold(
      appBar: AppBar(
        title: Text(accountsOnly ? 'Accounts' : 'Good day'),
        actions: [
          IconButton(
            tooltip: 'Activity',
            onPressed: () => context.push('/activity'),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!accountsOnly) ...[
            Text(session.profile?.name ?? 'Member'),
            const SizedBox(height: 12),
          ],
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ledger.accounts.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cross,
              mainAxisExtent: 150,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              final account = ledger.accounts[index];
              return NavyCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(account.name),
                    Text(account.maskedNumber),
                    const Spacer(),
                    Text(
                      account.kind == AccountKind.credit
                          ? 'Balance owed'
                          : 'Available',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    MoneyText(
                      account.available,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              );
            },
          ),
          if (!accountsOnly) ...[
            const SizedBox(height: 20),
            SectionTitle(
              'Cards',
              action: TextButton(
                  onPressed: () => context.push('/cards'),
                  child: const Text('View')),
            ),
            const SizedBox(height: 8),
            if (ledger.cards.isEmpty) const EmptyHint('No virtual cards.'),
            ...ledger.cards.map(
              (card) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${card.network} ${card.preview}'),
                subtitle: Text('${card.holder} · ${card.expiry}'),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ActionChip(
                    label: const Text('Pay someone'),
                    onPressed: () => context.go('/pay')),
                ActionChip(
                    label: const Text('History'),
                    onPressed: () => context.push('/transactions')),
                ActionChip(
                    label: const Text('Beneficiaries'),
                    onPressed: () => context.push('/beneficiaries')),
                ActionChip(
                    label: const Text('Budgets'),
                    onPressed: () => context.push('/budgets')),
              ],
            ),
            const SizedBox(height: 16),
            const SectionTitle('Recent activity'),
            if (ledger.transactions.isEmpty)
              const EmptyHint('No transactions yet.'),
            ...ledger.transactions.take(4).map((tx) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(tx.title),
                  subtitle: Text(tx.category),
                  trailing: MoneyText(tx.amount),
                )),
          ],
        ],
      ),
    );
  }
}
