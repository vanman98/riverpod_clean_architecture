import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_notifier.dart';
// import '../../transactions/presentation/transactions_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController(text: 'demo@example.com');
  final _passwordController = TextEditingController(text: '123456');

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider); // 1

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login (Finance Demo)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (state.error != null) // 2
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.red.withOpacity(0.1),
                child: Text(
                  state.error!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            state.isLoading // 3
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      await ref
                          .read(authNotifierProvider.notifier) // 4
                          .login(
                            _emailController.text,
                            _passwordController.text,
                          );

                      final user = ref.read(authNotifierProvider).user;
                      if (user != null && mounted) {
                        // Navigator.of(context).pushReplacement(
                        //   MaterialPageRoute(
                        //     builder: (_) => const TransactionsPage(), // 5
                        //   ),
                        // );
                      }
                    },
                    child: const Text('Login'),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
