import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../banking_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final mode = ref.watch(themeModeProvider);
    final profile = session.profile;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        children: [
          ListTile(
            title: Text(profile?.name ?? 'Guest'),
            subtitle: Text(profile?.email ?? ''),
          ),
          const ListTile(
            title: Text('Security'),
            subtitle: Text(
              'Passwords are checked against the local demo account. Nothing is sent to a bank. Biometrics are not enabled.',
            ),
          ),
          SwitchListTile(
            title: const Text('Dark theme'),
            value: mode == ThemeMode.dark,
            onChanged: (value) {
              ref.read(themeModeProvider.notifier).state =
                  value ? ThemeMode.dark : ThemeMode.light;
            },
          ),
          ListTile(
            title: const Text('Accounts'),
            onTap: () => context.push('/accounts'),
          ),
          ListTile(
            title: const Text('Sign out'),
            onTap: () async {
              await ref.read(sessionProvider.notifier).signOut();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
