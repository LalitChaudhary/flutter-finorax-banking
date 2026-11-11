import 'package:shared_preferences/shared_preferences.dart';

import '../../core/config/app_config.dart';
import '../../core/error/failures.dart';
import '../../domain/banking_repository.dart';
import '../../domain/entities.dart';
import '../../domain/money.dart';
import '../../domain/transfer_rules.dart';
import 'seed_data.dart';

/// In-memory ledger used for the demo. Transfers never move real money.
class MockBankingRepository implements BankingRepository {
  MockBankingRepository({TransferValidator? validator})
      : _validator = validator ?? const TransferValidator();

  final TransferValidator _validator;
  final List<BankAccount> _accounts = SeedData.accounts();
  final List<Beneficiary> _beneficiaries = SeedData.beneficiaries();
  final List<LedgerTransaction> _transactions = SeedData.transactions();
  final List<ActivityNotice> _notices = SeedData.notices();
  UserProfile? _session;

  @override
  Future<UserProfile?> signIn(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final ok = email.trim().toLowerCase() == AppConfig.demoEmail &&
        password == AppConfig.demoPassword;
    if (!ok) {
      throw const AuthFailure(
          'Use the demo email and password on the sign-in screen.');
    }
    _session = SeedData.profile;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('finorax_session', true);
    return _session;
  }

  @override
  Future<void> signOut() async {
    _session = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('finorax_session');
  }

  @override
  Future<List<BankAccount>> accounts() async => List.unmodifiable(_accounts);

  @override
  Future<List<VirtualCard>> cards() async => SeedData.cards();

  @override
  Future<List<Beneficiary>> beneficiaries() async =>
      List.unmodifiable(_beneficiaries);

  @override
  Future<void> addBeneficiary(Beneficiary beneficiary) async {
    _beneficiaries.add(beneficiary);
  }

  @override
  Future<List<LedgerTransaction>> transactions() async =>
      List.unmodifiable(_transactions);

  @override
  Future<TransferReceipt> transfer(TransferRequest request) async {
    final account = _findAccount(request.fromAccountId);
    Beneficiary? beneficiary;
    for (final item in _beneficiaries) {
      if (item.id == request.beneficiaryId) beneficiary = item;
    }
    final failure = _validator.validate(
      request: request,
      account: account,
      beneficiary: beneficiary,
    );
    if (failure != null) throw failure;
    final amount = Money(request.amountMinor);
    final index = _accounts.indexWhere((a) => a.id == account!.id);
    _accounts[index] = account!.copyWith(
      balance: account.balance - amount,
      available: account.available - amount,
    );
    final receipt = TransferReceipt(
      reference: 'FX${DateTime.now().millisecondsSinceEpoch}',
      fromAccountId: account.id,
      beneficiaryName: beneficiary!.name,
      amount: amount,
      note: request.note.trim(),
      createdAt: DateTime.now(),
    );
    _transactions.insert(
      0,
      LedgerTransaction(
        id: receipt.reference,
        accountId: account.id,
        title: 'Transfer to ${beneficiary.name}',
        category: 'Transfer',
        amount: amount,
        direction: TxDirection.debit,
        postedAt: receipt.createdAt,
        pending: false,
      ),
    );
    return receipt;
  }

  BankAccount? _findAccount(String id) {
    for (final account in _accounts) {
      if (account.id == id) return account;
    }
    return null;
  }

  @override
  Future<List<Budget>> budgets() async => SeedData.budgets();

  @override
  Future<List<SavingsGoal>> goals() async => SeedData.goals();

  @override
  Future<List<ActivityNotice>> notices() async => List.unmodifiable(_notices);

  @override
  Future<void> markNoticeRead(String id) async {
    final index = _notices.indexWhere((n) => n.id == id);
    if (index < 0) throw const NotFoundFailure('Notice not found.');
    _notices[index] = _notices[index].copyWith(read: true);
  }

  @override
  Future<UserProfile> profile() async => _session ?? SeedData.profile;
}
