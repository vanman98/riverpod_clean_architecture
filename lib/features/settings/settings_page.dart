import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_clean_architecture/features/auth/presentation/auth_notifier.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('App Settings (Demo)'),
            subtitle: Text('This is just a placeholder page'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            subtitle: const Text(
                'Sets isLoggedIn=false → router redirects to /login'),
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
            },
          ),
          const Divider(height: 1),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Tip:\n'
              'Logout sẽ đổi auth state.\n'
              'Router sẽ tự redirect về /login do redirect() trong GoRouter.',
            ),
          ),
        ],
      ),
    );
  }
}
