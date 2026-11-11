import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities.dart';
import '../banking_controller.dart';

class BeneficiariesPage extends ConsumerStatefulWidget {
  const BeneficiariesPage({super.key});

  @override
  ConsumerState<BeneficiariesPage> createState() => _BeneficiariesPageState();
}

class _BeneficiariesPageState extends ConsumerState<BeneficiariesPage> {
  final _name = TextEditingController();
  final _bank = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _bank.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final people = ref.watch(ledgerProvider).beneficiaries;
    return Scaffold(
      appBar: AppBar(title: const Text('Beneficiaries')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (people.isEmpty) const Text('No saved beneficiaries.'),
          ...people.map(
            (person) => ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(person.name),
              subtitle: Text('${person.bank} · ${person.maskedAccount}'),
            ),
          ),
          const Divider(),
          Text('Add a fictional payee',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 8),
          TextField(
              controller: _bank,
              decoration: const InputDecoration(labelText: 'Bank')),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () async {
              if (_name.text.trim().isEmpty || _bank.text.trim().isEmpty) {
                return;
              }
              await ref.read(ledgerProvider.notifier).addBeneficiary(
                    Beneficiary(
                      id: 'ben_${DateTime.now().millisecondsSinceEpoch}',
                      name: _name.text.trim(),
                      bank: _bank.text.trim(),
                      maskedAccount: '•••• 0000',
                      nickname: _name.text.trim(),
                    ),
                  );
              _name.clear();
              _bank.clear();
            },
            child: const Text('Save payee'),
          ),
        ],
      ),
    );
  }
}
