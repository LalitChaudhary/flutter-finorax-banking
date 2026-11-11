import '../../domain/entities.dart';
import '../../domain/money.dart';
import '../../domain/transfer_rules.dart';

abstract class BankingRepository {
  Future<UserProfile?> signIn(String email, String password);
  Future<void> signOut();
  Future<List<BankAccount>> accounts();
  Future<List<VirtualCard>> cards();
  Future<List<Beneficiary>> beneficiaries();
  Future<void> addBeneficiary(Beneficiary beneficiary);
  Future<List<LedgerTransaction>> transactions();
  Future<TransferReceipt> transfer(TransferRequest request);
  Future<List<Budget>> budgets();
  Future<List<SavingsGoal>> goals();
  Future<List<ActivityNotice>> notices();
  Future<void> markNoticeRead(String id);
  Future<UserProfile> profile();
}

class PageResult<T> {
  const PageResult({
    required this.items,
    required this.page,
    required this.total,
  });

  final List<T> items;
  final int page;
  final int total;

  int get pageCount => total == 0 ? 1 : (total / 8).ceil();
}

class CategorySpend {
  const CategorySpend(this.category, this.amount);
  final String category;
  final Money amount;
}
