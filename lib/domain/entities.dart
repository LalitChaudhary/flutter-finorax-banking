import 'package:equatable/equatable.dart';

import 'money.dart';

enum AccountKind { checking, savings, credit }

class BankAccount extends Equatable {
  const BankAccount({
    required this.id,
    required this.name,
    required this.maskedNumber,
    required this.kind,
    required this.balance,
    required this.available,
  });

  final String id;
  final String name;
  final String maskedNumber;
  final AccountKind kind;
  final Money balance;
  final Money available;

  BankAccount copyWith({Money? balance, Money? available}) {
    return BankAccount(
      id: id,
      name: name,
      maskedNumber: maskedNumber,
      kind: kind,
      balance: balance ?? this.balance,
      available: available ?? this.available,
    );
  }

  @override
  List<Object?> get props => [id, name, maskedNumber, kind, balance, available];
}

class VirtualCard extends Equatable {
  const VirtualCard({
    required this.id,
    required this.accountId,
    required this.holder,
    required this.last4,
    required this.network,
    required this.expiry,
    required this.frozen,
  });

  final String id;
  final String accountId;
  final String holder;
  final String last4;
  final String network;
  final String expiry;
  final bool frozen;

  /// Full PAN is never stored. Preview only shows the last four digits.
  String get preview => '•••• •••• •••• $last4';

  @override
  List<Object?> get props =>
      [id, accountId, holder, last4, network, expiry, frozen];
}

enum TxDirection { credit, debit }

class LedgerTransaction extends Equatable {
  const LedgerTransaction({
    required this.id,
    required this.accountId,
    required this.title,
    required this.category,
    required this.amount,
    required this.direction,
    required this.postedAt,
    required this.pending,
  });

  final String id;
  final String accountId;
  final String title;
  final String category;
  final Money amount;
  final TxDirection direction;
  final DateTime postedAt;
  final bool pending;

  int get signedMinor =>
      direction == TxDirection.credit ? amount.minor : -amount.minor;

  @override
  List<Object?> get props =>
      [id, accountId, title, category, amount, direction, postedAt, pending];
}

class Beneficiary extends Equatable {
  const Beneficiary({
    required this.id,
    required this.name,
    required this.bank,
    required this.maskedAccount,
    required this.nickname,
  });

  final String id;
  final String name;
  final String bank;
  final String maskedAccount;
  final String nickname;

  @override
  List<Object?> get props => [id, name, bank, maskedAccount, nickname];
}

class Budget extends Equatable {
  const Budget({
    required this.id,
    required this.category,
    required this.limit,
    required this.spent,
  });

  final String id;
  final String category;
  final Money limit;
  final Money spent;

  double get ratio => limit.minor == 0 ? 0 : spent.minor / limit.minor;

  @override
  List<Object?> get props => [id, category, limit, spent];
}

class SavingsGoal extends Equatable {
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.target,
    required this.saved,
    required this.targetDate,
  });

  final String id;
  final String name;
  final Money target;
  final Money saved;
  final DateTime targetDate;

  double get ratio => target.minor == 0 ? 0 : saved.minor / target.minor;

  @override
  List<Object?> get props => [id, name, target, saved, targetDate];
}

class ActivityNotice extends Equatable {
  const ActivityNotice({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.read,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;

  ActivityNotice copyWith({bool? read}) => ActivityNotice(
        id: id,
        title: title,
        body: body,
        createdAt: createdAt,
        read: read ?? this.read,
      );

  @override
  List<Object?> get props => [id, title, body, createdAt, read];
}

class UserProfile extends Equatable {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.memberSince,
  });

  final String id;
  final String name;
  final String email;
  final DateTime memberSince;

  @override
  List<Object?> get props => [id, name, email, memberSince];
}

class TransferReceipt extends Equatable {
  const TransferReceipt({
    required this.reference,
    required this.fromAccountId,
    required this.beneficiaryName,
    required this.amount,
    required this.note,
    required this.createdAt,
  });

  final String reference;
  final String fromAccountId;
  final String beneficiaryName;
  final Money amount;
  final String note;
  final DateTime createdAt;

  @override
  List<Object?> get props =>
      [reference, fromAccountId, beneficiaryName, amount, note, createdAt];
}

class TxQuery {
  const TxQuery({
    this.accountId,
    this.category,
    this.direction,
    this.search = '',
    this.page = 1,
    this.pageSize = 8,
  });

  final String? accountId;
  final String? category;
  final TxDirection? direction;
  final String search;
  final int page;
  final int pageSize;
}
