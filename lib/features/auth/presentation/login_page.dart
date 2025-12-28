import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_clean_architecture/app/router/app_routes.dart';
import 'package:riverpod_clean_architecture/core/utils/validators.dart';

import 'auth_notifier.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController(text: 'demo@example.com');
  final _passwordController = TextEditingController(text: '123456');

  @override
  void initState() {
    super.initState();

    /// Side-effects: show error / navigate
    ref.listenManual(authProvider, (prev, next) {
      // show error when it changes
      if (next.error != null && next.error != prev?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }

      // navigate when first time logged in
      final wasLoggedIn = prev?.user != null;
      final isLoggedIn = next.user != null;

      if (wasLoggedIn == false && isLoggedIn == true) {
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authProvider.select((s) => s.isLoading));
    return Scaffold(
      appBar: AppBar(title: const Text('Login (Finance Demo)')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            AbsorbPointer(
              absorbing: isLoading, // disable inputs while loading
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    validator: Validators.email,
                    style: TextStyle(fontSize: 16.sp),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(fontSize: 14.sp),
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 16.h,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    validator: Validators.password,
                    style: TextStyle(fontSize: 16.sp),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 14.sp),
                      border: const OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 16.h,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(authProvider.notifier).login(
                              _emailController.text.trim(),
                              _passwordController.text,
                            );
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
