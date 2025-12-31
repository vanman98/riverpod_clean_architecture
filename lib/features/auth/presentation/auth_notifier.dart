import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_clean_architecture/core/errors/failure.dart';
import 'package:riverpod_clean_architecture/core/usecases/usecase.dart';
import 'package:riverpod_clean_architecture/features/auth/di/auth_providers.dart';
import 'package:riverpod_clean_architecture/features/auth/domain/usecases.dart';
import 'package:riverpod_clean_architecture/features/auth/presentation/state/auth_state.dart';

part 'auth_notifier.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final LoginUseCase _loginUseCase;
  late final LogoutUseCase _logoutUseCase;

  @override
  AuthState build() {
    // ✅ “inject” dependency here
    _loginUseCase = ref.watch(loginUseCaseProvider);
    _logoutUseCase = ref.watch(logoutUseCaseProvider);

    // state init
    return const AuthState();
  }

  Future<void> login(String email, String password, BuildContext context) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _loginUseCase(
      LoginParams(email: email, password: password),
    );

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          error: failure.localizedMessage(context),
        );
      },
      (user) {
        // Login success
        state = state.copyWith(
          isLoading: false,
          user: user,
          error: null,
        );
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _logoutUseCase(const NoParams());

    result.fold(
      (failure) {
        // Even if logout fails, clear local state
        state = const AuthState();
      },
      (_) {
        // Logout success
        state = const AuthState();
      },
    );
  }
}
