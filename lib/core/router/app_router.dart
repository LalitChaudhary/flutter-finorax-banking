import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/banking_controller.dart';
import '../../presentation/pages/activity_page.dart';
import '../../presentation/pages/analytics_page.dart';
import '../../presentation/pages/auth_pages.dart';
import '../../presentation/pages/beneficiaries_page.dart';
import '../../presentation/pages/budgets_page.dart';
import '../../presentation/pages/cards_page.dart';
import '../../presentation/pages/dashboard_page.dart';
import '../../presentation/pages/profile_page.dart';
import '../../presentation/pages/transactions_page.dart';
import '../../presentation/pages/transfer_page.dart';
import '../../presentation/shell/home_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final refresh = ValueNotifier<int>(0);
  ref.listen(sessionProvider, (_, __) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: refresh,
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final loc = state.location;
      final authed = session.signedIn;
      if (loc == '/splash') return null;
      if (!session.seenOnboarding && loc != '/onboarding' && !authed) {
        return '/onboarding';
      }
      final public = loc == '/onboarding' || loc == '/login';
      if (!authed && !public) return '/login';
      if (authed && public) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashPage()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      ShellRoute(
        builder: (_, __, child) => HomeShell(child: child),
        routes: [
          GoRoute(path: '/home', builder: (_, __) => const DashboardPage()),
          GoRoute(path: '/pay', builder: (_, __) => const TransferPage()),
          GoRoute(path: '/insights', builder: (_, __) => const AnalyticsPage()),
          GoRoute(path: '/more', builder: (_, __) => const ProfilePage()),
        ],
      ),
      GoRoute(
          path: '/accounts',
          builder: (_, __) => const DashboardPage(accountsOnly: true)),
      GoRoute(path: '/cards', builder: (_, __) => const CardsPage()),
      GoRoute(
          path: '/beneficiaries',
          builder: (_, __) => const BeneficiariesPage()),
      GoRoute(
          path: '/transactions', builder: (_, __) => const TransactionsPage()),
      GoRoute(path: '/budgets', builder: (_, __) => const BudgetsPage()),
      GoRoute(path: '/activity', builder: (_, __) => const ActivityPage()),
    ],
  );
});
