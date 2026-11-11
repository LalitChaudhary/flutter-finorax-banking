import '../../domain/entities.dart';
import '../../domain/money.dart';

class SeedData {
  static final profile = UserProfile(
    id: 'usr_avery',
    name: 'Avery Cole',
    email: 'avery.cole@finorax.dev',
    memberSince: DateTime(2022, 4, 11),
  );

  static List<BankAccount> accounts() => [
        const BankAccount(
          id: 'acc_everyday',
          name: 'Everyday Checking',
          maskedNumber: '•••• 4418',
          kind: AccountKind.checking,
          balance: Money(482350),
          available: Money(468900),
        ),
        const BankAccount(
          id: 'acc_reserve',
          name: 'Reserve Savings',
          maskedNumber: '•••• 9021',
          kind: AccountKind.savings,
          balance: Money(1260400),
          available: Money(1260400),
        ),
        const BankAccount(
          id: 'acc_harbor',
          name: 'Harbor Credit',
          maskedNumber: '•••• 1184',
          kind: AccountKind.credit,
          balance: Money(-64220),
          available: Money(435780),
        ),
      ];

  static List<VirtualCard> cards() => const [
        VirtualCard(
          id: 'card_1',
          accountId: 'acc_everyday',
          holder: 'AVERY COLE',
          last4: '4418',
          network: 'Harbor',
          expiry: '08/28',
          frozen: false,
        ),
        VirtualCard(
          id: 'card_2',
          accountId: 'acc_harbor',
          holder: 'AVERY COLE',
          last4: '1184',
          network: 'Nimbus',
          expiry: '01/27',
          frozen: false,
        ),
      ];

  static List<Beneficiary> beneficiaries() => const [
        Beneficiary(
          id: 'ben_1',
          name: 'Mina Okonkwo',
          bank: 'Northline Credit',
          maskedAccount: '•••• 2204',
          nickname: 'Mina',
        ),
        Beneficiary(
          id: 'ben_2',
          name: 'Cedar Rentals LLC',
          bank: 'Atlas Business',
          maskedAccount: '•••• 7781',
          nickname: 'Rent',
        ),
        Beneficiary(
          id: 'ben_3',
          name: 'Jonah Ellis',
          bank: 'FinoraX',
          maskedAccount: '•••• 6630',
          nickname: 'Jonah',
        ),
      ];

  static List<LedgerTransaction> transactions() {
    final now = DateTime.now();
    return [
      LedgerTransaction(
        id: 'tx_1',
        accountId: 'acc_everyday',
        title: 'Harbor Market',
        category: 'Groceries',
        amount: const Money(8640),
        direction: TxDirection.debit,
        postedAt: now.subtract(const Duration(hours: 6)),
        pending: false,
      ),
      LedgerTransaction(
        id: 'tx_2',
        accountId: 'acc_everyday',
        title: 'Lumen Payroll',
        category: 'Income',
        amount: const Money(245000),
        direction: TxDirection.credit,
        postedAt: now.subtract(const Duration(days: 2)),
        pending: false,
      ),
      LedgerTransaction(
        id: 'tx_3',
        accountId: 'acc_everyday',
        title: 'City Transit',
        category: 'Transport',
        amount: const Money(2400),
        direction: TxDirection.debit,
        postedAt: now.subtract(const Duration(days: 3)),
        pending: false,
      ),
      LedgerTransaction(
        id: 'tx_4',
        accountId: 'acc_harbor',
        title: 'North Cafe',
        category: 'Dining',
        amount: const Money(1860),
        direction: TxDirection.debit,
        postedAt: now.subtract(const Duration(days: 1)),
        pending: true,
      ),
      LedgerTransaction(
        id: 'tx_5',
        accountId: 'acc_reserve',
        title: 'Automatic Save',
        category: 'Transfer',
        amount: const Money(20000),
        direction: TxDirection.credit,
        postedAt: now.subtract(const Duration(days: 4)),
        pending: false,
      ),
      LedgerTransaction(
        id: 'tx_6',
        accountId: 'acc_everyday',
        title: 'Cedar Rentals',
        category: 'Housing',
        amount: const Money(145000),
        direction: TxDirection.debit,
        postedAt: now.subtract(const Duration(days: 8)),
        pending: false,
      ),
      LedgerTransaction(
        id: 'tx_7',
        accountId: 'acc_everyday',
        title: 'Kinetic Power',
        category: 'Utilities',
        amount: const Money(9420),
        direction: TxDirection.debit,
        postedAt: now.subtract(const Duration(days: 10)),
        pending: false,
      ),
      LedgerTransaction(
        id: 'tx_8',
        accountId: 'acc_harbor',
        title: 'Page & Binding',
        category: 'Shopping',
        amount: const Money(3290),
        direction: TxDirection.debit,
        postedAt: now.subtract(const Duration(days: 12)),
        pending: false,
      ),
      LedgerTransaction(
        id: 'tx_9',
        accountId: 'acc_everyday',
        title: 'Rivergate Clinic',
        category: 'Health',
        amount: const Money(4500),
        direction: TxDirection.debit,
        postedAt: now.subtract(const Duration(days: 14)),
        pending: false,
      ),
      LedgerTransaction(
        id: 'tx_10',
        accountId: 'acc_everyday',
        title: 'Interest Credit',
        category: 'Income',
        amount: const Money(640),
        direction: TxDirection.credit,
        postedAt: now.subtract(const Duration(days: 16)),
        pending: false,
      ),
    ];
  }

  static List<Budget> budgets() => const [
        Budget(
          id: 'bud_1',
          category: 'Groceries',
          limit: Money(40000),
          spent: Money(18640),
        ),
        Budget(
          id: 'bud_2',
          category: 'Dining',
          limit: Money(18000),
          spent: Money(12400),
        ),
        Budget(
          id: 'bud_3',
          category: 'Transport',
          limit: Money(12000),
          spent: Money(4100),
        ),
      ];

  static List<SavingsGoal> goals() => [
        SavingsGoal(
          id: 'goal_1',
          name: 'Lisbon trip',
          target: const Money(350000),
          saved: const Money(186000),
          targetDate: DateTime(2027, 6, 1),
        ),
        SavingsGoal(
          id: 'goal_2',
          name: 'Emergency reserve',
          target: const Money(1000000),
          saved: const Money(640000),
          targetDate: DateTime(2027, 12, 1),
        ),
      ];

  static List<ActivityNotice> notices() => [
        ActivityNotice(
          id: 'nt_1',
          title: 'Payroll posted',
          body:
              'Lumen Payroll credited Everyday Checking. This is sample activity.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          read: false,
        ),
        ActivityNotice(
          id: 'nt_2',
          title: 'Budget watch',
          body: 'Dining is at 69% of this month\'s sample budget.',
          createdAt: DateTime.now().subtract(const Duration(hours: 20)),
          read: false,
        ),
        ActivityNotice(
          id: 'nt_3',
          title: 'Card preview',
          body: 'Virtual cards in FinoraX never store a real PAN.',
          createdAt: DateTime.now().subtract(const Duration(days: 6)),
          read: true,
        ),
      ];
}
