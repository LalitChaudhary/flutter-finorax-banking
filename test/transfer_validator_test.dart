import 'package:finorax/domain/entities.dart';
import 'package:finorax/domain/money.dart';
import 'package:finorax/domain/transfer_rules.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const validator = TransferValidator();
  const checking = BankAccount(
    id: 'a',
    name: 'Checking',
    maskedNumber: '•••• 1',
    kind: AccountKind.checking,
    balance: Money(100000),
    available: Money(80000),
  );
  const credit = BankAccount(
    id: 'c',
    name: 'Credit',
    maskedNumber: '•••• 2',
    kind: AccountKind.credit,
    balance: Money(-1000),
    available: Money(50000),
  );
  const payee = Beneficiary(
    id: 'b',
    name: 'Mina',
    bank: 'Northline',
    maskedAccount: '•••• 9',
    nickname: 'Mina',
  );

  test('rejects transfers below one dollar', () {
    final failure = validator.validate(
      request: const TransferRequest(
        fromAccountId: 'a',
        beneficiaryId: 'b',
        amountMinor: 50,
        note: '',
      ),
      account: checking,
      beneficiary: payee,
    );
    expect(failure, isNotNull);
  });

  test('rejects amounts above available balance', () {
    final failure = validator.validate(
      request: const TransferRequest(
        fromAccountId: 'a',
        beneficiaryId: 'b',
        amountMinor: 90000,
        note: 'rent',
      ),
      account: checking,
      beneficiary: payee,
    );
    expect(failure!.message, contains('available'));
  });

  test('rejects credit-account source', () {
    final failure = validator.validate(
      request: const TransferRequest(
        fromAccountId: 'c',
        beneficiaryId: 'b',
        amountMinor: 200,
        note: '',
      ),
      account: credit,
      beneficiary: payee,
    );
    expect(failure, isNotNull);
  });

  test('accepts a valid demo transfer', () {
    final failure = validator.validate(
      request: const TransferRequest(
        fromAccountId: 'a',
        beneficiaryId: 'b',
        amountMinor: 2500,
        note: 'lunch',
      ),
      account: checking,
      beneficiary: payee,
    );
    expect(failure, isNull);
  });
}
