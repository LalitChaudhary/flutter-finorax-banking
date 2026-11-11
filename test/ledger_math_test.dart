import 'package:finorax/domain/entities.dart';
import 'package:finorax/domain/money.dart';
import 'package:finorax/domain/transfer_rules.dart';
import 'package:flutter_test/flutter_test.dart';

LedgerTransaction tx({
  required String id,
  required String category,
  required TxDirection direction,
  required int minor,
  required int daysAgo,
}) {
  return LedgerTransaction(
    id: id,
    accountId: 'acc',
    title: category,
    category: category,
    amount: Money(minor),
    direction: direction,
    postedAt: DateTime(2026, 1, 20).subtract(Duration(days: daysAgo)),
    pending: false,
  );
}

void main() {
  const filter = TransactionFilter();
  const calculator = BalanceCalculator();
  final items = [
    tx(
        id: '1',
        category: 'Dining',
        direction: TxDirection.debit,
        minor: 1500,
        daysAgo: 1),
    tx(
        id: '2',
        category: 'Income',
        direction: TxDirection.credit,
        minor: 5000,
        daysAgo: 2),
    tx(
        id: '3',
        category: 'Dining',
        direction: TxDirection.debit,
        minor: 700,
        daysAgo: 4),
  ];

  test('filters by category and paginates', () {
    const query = TxQuery(category: 'Dining', pageSize: 1);
    final filtered = filter.apply(items, query);
    expect(filtered, hasLength(2));
    expect(filter.page(filtered, query).single.id, '1');
    expect(
        filter
            .page(filtered,
                const TxQuery(category: 'Dining', page: 2, pageSize: 1))
            .single
            .id,
        '3');
  });

  test('nets credits and debits in minor units', () {
    expect(calculator.netMinor(items), 5000 - 1500 - 700);
  });

  test('sums debit spend by category', () {
    expect(calculator.spendByCategory(items)['Dining'], 2200);
    expect(calculator.spendByCategory(items).containsKey('Income'), isFalse);
  });

  test('money subtraction stays in cents', () {
    const left = Money(1050);
    const right = Money(25);
    expect((left - right).minor, 1025);
    expect((left - right).format(), contains('10.25'));
  });
}
