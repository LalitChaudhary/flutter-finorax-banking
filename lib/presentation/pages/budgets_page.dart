import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../banking_controller.dart';
import '../widgets/common.dart';

class BudgetsPage extends ConsumerWidget {
  const BudgetsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ledger = ref.watch(ledgerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Budgets & goals')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionTitle('Monthly budgets'),
          if (ledger.budgets.isEmpty) const EmptyHint('No budgets yet.'),
          ...ledger.budgets.map(
            (budget) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${budget.category} · ${budget.spent.format()} of ${budget.limit.format()}'),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                      value: budget.ratio.clamp(0, 1).toDouble()),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          const SectionTitle('Savings goals'),
          if (ledger.goals.isEmpty) const EmptyHint('No goals yet.'),
          ...ledger.goals.map(
            (goal) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(goal.name),
              subtitle: Text(
                '${goal.saved.format()} saved of ${goal.target.format()} · target ${goal.targetDate.year}',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
