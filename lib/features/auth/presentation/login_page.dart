import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_clean_architecture/app/router/app_routes.dart';
import 'package:riverpod_clean_architecture/core/utils/validators.dart';
import 'package:riverpod_clean_architecture/features/auth/presentation/auth_notifier.dart';
import 'package:riverpod_clean_architecture/l10n/app_localizations.dart';
import 'package:riverpod_clean_architecture/shared/widgets/custom_button.dart';
import 'package:riverpod_clean_architecture/shared/widgets/custom_text_field.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController(text: 'demo@example.com');
  final _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    ref.listenManual(authProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        final l10n = AppLocalizations.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: l10n.close,
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }

      final wasLoggedIn = prev?.user != null;
      final isLoggedIn = next.user != null;

      if (wasLoggedIn == false && isLoggedIn == true) {
        context.go(AppRoutes.home);
      }
    });
  }

  void _handleLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      ref.read(authProvider.notifier).login(
            _emailController.text.trim(),
            _passwordController.text,
            context
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loginTitle)),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.loginHeader,
                style:
                    const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48.h),
              CustomTextField(
                label: l10n.email,
                hint: l10n.emailHint,
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email,
                validator: (value) => Validators.email(value, context),
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: 16.h),
              CustomTextField(
                label: l10n.password,
                hint: l10n.passwordHint,
                controller: _passwordController,
                obscureText: true,
                prefixIcon: Icons.lock,
                validator: (value) => Validators.password(value, context),
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _handleLogin(),
              ),
              SizedBox(height: 32.h),
              CustomButton(
                text: l10n.login,
                onPressed: authState.isLoading ? null : _handleLogin,
                isLoading: authState.isLoading,
                isExpanded: true,
                icon: Icons.login,
                type: ButtonType.primary,
              ),
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            size: 16.sp, color: Colors.blue.shade700),
                        SizedBox(width: 8.w),
                        Text(
                          l10n.demoCredentials,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      l10n.demoCredentialsInfo,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
