import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            if (state.error != null) // 2
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(8.w),
                color: Colors.red.withOpacity(0.1),
                child: Text(
                  state.error!,
                  style: TextStyle(color: Colors.red, fontSize: 14.sp),
                ),
              ),
            TextField(
              controller: _emailController,
              style: TextStyle(fontSize: 16.sp),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(fontSize: 14.sp),
                border: const OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(fontSize: 16.sp),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(fontSize: 14.sp),
                border: const OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
              ),
            ),
            SizedBox(height: 20.h),
            state.isLoading // 3
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
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
                      child: Text('Login', style: TextStyle(fontSize: 16.sp)),
                    ),
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
