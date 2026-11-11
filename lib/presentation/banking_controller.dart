import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/error/failures.dart';
import '../../domain/banking_repository.dart';
import '../../domain/entities.dart';
import '../../domain/transfer_rules.dart';
import '../../data/mock_banking_repository.dart';

final bankingRepositoryProvider = Provider<BankingRepository>(
  (ref) => MockBankingRepository(),
);

class SessionState {
  const SessionState({
    this.profile,
    this.loading = false,
    this.error,
    this.seenOnboarding = false,
  });

  final UserProfile? profile;
  final bool loading;
  final String? error;
  final bool seenOnboarding;

  bool get signedIn => profile != null;

  SessionState copyWith({
    UserProfile? profile,
    bool? loading,
    String? error,
    bool? seenOnboarding,
    bool clearError = false,
    bool clearProfile = false,
  }) {
    return SessionState(
      profile: clearProfile ? null : (profile ?? this.profile),
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      seenOnboarding: seenOnboarding ?? this.seenOnboarding,
    );
  }
}

class SessionController extends StateNotifier<SessionState> {
  SessionController(this._repository) : super(const SessionState());

  final BankingRepository _repository;

  void completeOnboarding() {
    state = state.copyWith(seenOnboarding: true);
  }

  Future<bool> signIn(String email, String password) async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final profile = await _repository.signIn(email, password);
      state = state.copyWith(loading: false, profile: profile);
      return true;
    } on Failure catch (error) {
      state = state.copyWith(loading: false, error: error.message);
      return false;
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = state.copyWith(clearProfile: true);
  }
}

final sessionProvider =
    StateNotifierProvider<SessionController, SessionState>((ref) {
  return SessionController(ref.watch(bankingRepositoryProvider));
});

class LedgerState {
  const LedgerState({
    this.loading = true,
    this.error,
    this.accounts = const [],
    this.cards = const [],
    this.beneficiaries = const [],
    this.transactions = const [],
    this.budgets = const [],
    this.goals = const [],
    this.notices = const [],
    this.receipt,
    this.query = const TxQuery(),
  });

  final bool loading;
  final String? error;
  final List<BankAccount> accounts;
  final List<VirtualCard> cards;
  final List<Beneficiary> beneficiaries;
  final List<LedgerTransaction> transactions;
  final List<Budget> budgets;
  final List<SavingsGoal> goals;
  final List<ActivityNotice> notices;
  final TransferReceipt? receipt;
  final TxQuery query;

  LedgerState copyWith({
    bool? loading,
    String? error,
    bool clearError = false,
    List<BankAccount>? accounts,
    List<VirtualCard>? cards,
    List<Beneficiary>? beneficiaries,
    List<LedgerTransaction>? transactions,
    List<Budget>? budgets,
    List<SavingsGoal>? goals,
    List<ActivityNotice>? notices,
    TransferReceipt? receipt,
    TxQuery? query,
  }) {
    return LedgerState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      accounts: accounts ?? this.accounts,
      cards: cards ?? this.cards,
      beneficiaries: beneficiaries ?? this.beneficiaries,
      transactions: transactions ?? this.transactions,
      budgets: budgets ?? this.budgets,
      goals: goals ?? this.goals,
      notices: notices ?? this.notices,
      receipt: receipt ?? this.receipt,
      query: query ?? this.query,
    );
  }
}

class LedgerController extends StateNotifier<LedgerState> {
  LedgerController(this._repository) : super(const LedgerState()) {
    refresh();
  }

  final BankingRepository _repository;
  final _filter = const TransactionFilter();

  List<LedgerTransaction> get visible {
    final filtered = _filter.apply(state.transactions, state.query);
    return _filter.page(filtered, state.query);
  }

  int get totalFiltered =>
      _filter.apply(state.transactions, state.query).length;

  Future<void> refresh() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      final results = await Future.wait([
        _repository.accounts(),
        _repository.cards(),
        _repository.beneficiaries(),
        _repository.transactions(),
        _repository.budgets(),
        _repository.goals(),
        _repository.notices(),
      ]);
      state = state.copyWith(
        loading: false,
        accounts: results[0] as List<BankAccount>,
        cards: results[1] as List<VirtualCard>,
        beneficiaries: results[2] as List<Beneficiary>,
        transactions: results[3] as List<LedgerTransaction>,
        budgets: results[4] as List<Budget>,
        goals: results[5] as List<SavingsGoal>,
        notices: results[6] as List<ActivityNotice>,
      );
    } on Failure catch (error) {
      state = state.copyWith(loading: false, error: error.message);
    }
  }

  void setQuery(TxQuery query) {
    state = state.copyWith(query: query);
  }

  Future<TransferReceipt?> send(TransferRequest request) async {
    state = state.copyWith(clearError: true);
    try {
      final receipt = await _repository.transfer(request);
      await refresh();
      state = state.copyWith(receipt: receipt);
      return receipt;
    } on Failure catch (error) {
      state = state.copyWith(error: error.message);
      return null;
    }
  }

  Future<void> addBeneficiary(Beneficiary beneficiary) async {
    await _repository.addBeneficiary(beneficiary);
    await refresh();
  }

  Future<void> markRead(String id) async {
    await _repository.markNoticeRead(id);
    await refresh();
  }
}

final ledgerProvider =
    StateNotifierProvider<LedgerController, LedgerState>((ref) {
  return LedgerController(ref.watch(bankingRepositoryProvider));
});

final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
