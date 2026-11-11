import '../core/error/failures.dart';
import 'entities.dart';

class TransferRequest {
  const TransferRequest({
    required this.fromAccountId,
    required this.beneficiaryId,
    required this.amountMinor,
    required this.note,
  });

  final String fromAccountId;
  final String beneficiaryId;
  final int amountMinor;
  final String note;
}

class TransferValidator {
  const TransferValidator();

  static const minMinor = 100;
  static const maxMinor = 500000;

  ValidationFailure? validate({
    required TransferRequest request,
    required BankAccount? account,
    required Beneficiary? beneficiary,
  }) {
    if (account == null) {
      return const ValidationFailure('Choose an account.');
    }
    if (account.kind == AccountKind.credit) {
      return const ValidationFailure(
        'Transfers from credit accounts are disabled in this demo.',
      );
    }
    if (beneficiary == null) {
      return const ValidationFailure('Choose a beneficiary.');
    }
    if (request.amountMinor < minMinor) {
      return const ValidationFailure('Minimum transfer is \$1.00.');
    }
    if (request.amountMinor > maxMinor) {
      return const ValidationFailure('Demo limit is \$5,000.00 per transfer.');
    }
    if (request.amountMinor > account.available.minor) {
      return const ValidationFailure('Amount exceeds available balance.');
    }
    if (request.note.trim().length > 80) {
      return const ValidationFailure('Note must be 80 characters or fewer.');
    }
    return null;
  }
}

class TransactionFilter {
  const TransactionFilter();

  List<LedgerTransaction> apply(
    List<LedgerTransaction> source,
    TxQuery query,
  ) {
    final term = query.search.trim().toLowerCase();
    final filtered = source.where((tx) {
      if (query.accountId != null && tx.accountId != query.accountId) {
        return false;
      }
      if (query.category != null && tx.category != query.category) {
        return false;
      }
      if (query.direction != null && tx.direction != query.direction) {
        return false;
      }
      if (term.isEmpty) return true;
      return tx.title.toLowerCase().contains(term) ||
          tx.category.toLowerCase().contains(term);
    }).toList()
      ..sort((a, b) => b.postedAt.compareTo(a.postedAt));
    return filtered;
  }

  List<LedgerTransaction> page(
      List<LedgerTransaction> filtered, TxQuery query) {
    final start = (query.page - 1) * query.pageSize;
    if (start >= filtered.length || start < 0) return const [];
    final end = (start + query.pageSize).clamp(0, filtered.length);
    return filtered.sublist(start, end);
  }
}

class BalanceCalculator {
  const BalanceCalculator();

  int netMinor(List<LedgerTransaction> items) {
    return items.fold(0, (sum, tx) => sum + tx.signedMinor);
  }

  Map<String, int> spendByCategory(List<LedgerTransaction> items) {
    final map = <String, int>{};
    for (final tx in items) {
      if (tx.direction != TxDirection.debit) continue;
      map[tx.category] = (map[tx.category] ?? 0) + tx.amount.minor;
    }
    return map;
  }
}
