import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key, required this.child});

  final Widget child;

  int _index(String location) {
    if (location.startsWith('/pay')) return 1;
    if (location.startsWith('/insights')) return 2;
    if (location.startsWith('/more')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).location;
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index(location),
        onDestinationSelected: (index) {
          switch (index) {
            case 1:
              context.go('/pay');
              break;
            case 2:
              context.go('/insights');
              break;
            case 3:
              context.go('/more');
              break;
            default:
              context.go('/home');
          }
        },
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.account_balance_outlined), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.swap_horiz), label: 'Pay'),
          NavigationDestination(
              icon: Icon(Icons.insights_outlined), label: 'Insights'),
          NavigationDestination(icon: Icon(Icons.tune), label: 'More'),
        ],
      ),
    );
  }
}
