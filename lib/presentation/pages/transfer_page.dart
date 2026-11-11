import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities.dart';
import '../../domain/transfer_rules.dart';
import '../banking_controller.dart';
import '../widgets/common.dart';

class TransferPage extends ConsumerStatefulWidget {
  const TransferPage({super.key});

  @override
  ConsumerState<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends ConsumerState<TransferPage> {
  String? _accountId;
  String? _beneficiaryId;
  final _amount = TextEditingController();
  final _note = TextEditingController();
  bool _confirming = false;

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ledger = ref.watch(ledgerProvider);
    final sources =
        ledger.accounts.where((a) => a.kind != AccountKind.credit).toList();
    final receipt = ledger.receipt;
    return Scaffold(
      appBar: AppBar(title: const Text('Simulated transfer')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const StatusBanner(
            message:
                'This transfer updates the local demo ledger only. No bank payment is sent.',
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _accountId,
            decoration: const InputDecoration(labelText: 'From'),
            items: sources
                .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                .toList(),
            onChanged: (value) => setState(() => _accountId = value),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _beneficiaryId,
            decoration: const InputDecoration(labelText: 'To'),
            items: ledger.beneficiaries
                .map((b) => DropdownMenuItem(value: b.id, child: Text(b.name)))
                .toList(),
            onChanged: (value) => setState(() => _beneficiaryId = value),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amount,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Amount (USD)'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _note,
            decoration: const InputDecoration(labelText: 'Note'),
          ),
          const SizedBox(height: 16),
          if (ledger.error != null)
            StatusBanner(message: ledger.error!, error: true),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => setState(() => _confirming = true),
            child: const Text('Review'),
          ),
          if (_confirming) ...[
            const SizedBox(height: 12),
            Text(
                'Confirm a simulated payment of \$${_amount.text.isEmpty ? '0' : _amount.text}?'),
            const SizedBox(height: 8),
            FilledButton.tonal(
              onPressed: () async {
                final minor =
                    ((double.tryParse(_amount.text) ?? 0) * 100).round();
                final result = await ref.read(ledgerProvider.notifier).send(
                      TransferRequest(
                        fromAccountId: _accountId ?? '',
                        beneficiaryId: _beneficiaryId ?? '',
                        amountMinor: minor,
                        note: _note.text,
                      ),
                    );
                if (result != null && context.mounted) {
                  setState(() => _confirming = false);
                }
              },
              child: const Text('Confirm demo transfer'),
            ),
          ],
          if (receipt != null) ...[
            const SizedBox(height: 20),
            Text('Receipt ${receipt.reference}',
                style: Theme.of(context).textTheme.titleMedium),
            Text('To ${receipt.beneficiaryName}'),
            MoneyText(receipt.amount),
            Text(receipt.note.isEmpty ? 'No note' : receipt.note),
          ],
        ],
      ),
    );
  }
}
