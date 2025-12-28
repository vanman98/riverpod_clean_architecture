import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_clean_architecture/app/router/app_routes.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Finance Demo Home',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Go to Transactions tab'),
            subtitle: const Text('context.go(/transactions)'),
            onTap: () => context.go(AppRoutes.transactions),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Go to Settings tab'),
            subtitle: const Text('context.go(/settings)'),
            onTap: () => context.go(AppRoutes.settings),
          ),
          const Divider(height: 32),
          ListTile(
            leading: const Icon(Icons.open_in_new),
            title: const Text('Open TX detail via deep link'),
            subtitle: const Text('context.go(/transactions/TX-1)'),
            onTap: () => context.go(AppRoutes.transactionDetail('TX-1')),
          ),
          const SizedBox(height: 24),
          const Text(
            'Tip:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Text(
            '• go() thường dùng để nhảy tab/màn chính.\n'
            '• push() dùng để mở màn con (detail) để back về list.',
          ),
        ],
      ),
    );
  }
}
