import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:riverpod_clean_architecture/core/di/app_providers.dart';
import 'package:riverpod_clean_architecture/core/usecases/usecase.dart';
import 'package:riverpod_clean_architecture/core/network/api_client.dart';
import 'package:riverpod_clean_architecture/features/auth/domain/entities.dart';
import 'package:riverpod_clean_architecture/features/auth/domain/repository.dart';
import 'package:riverpod_clean_architecture/features/auth/domain/usecases.dart';
import 'package:riverpod_clean_architecture/features/auth/data/datasources.dart';
import 'package:riverpod_clean_architecture/features/auth/data/repository_impl.dart';
import 'package:riverpod_clean_architecture/features/auth/presentation/state/auth_state.dart';

// ---------- NOTIFIER ----------
class AuthNotifier extends StateNotifier<AuthState> {
  final LoginUseCase _loginUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthNotifier(this._loginUseCase, this._logoutUseCase)
      : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final user = await _loginUseCase(
        LoginParams(email: email, password: password),
      );
      state = state.copyWith(isLoading: false, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);

    try {
      await _logoutUseCase(const NoParams());
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

// ---------- PROVIDERS (DI) ----------

// 2) Remote data source
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = ref.watch(apiClientProvider);
  return AuthRemoteDataSourceImpl(client);
});

// 3) Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remote);
});

// 4) UseCases
final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LoginUseCase(repo);
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repo);
});

// 5) Notifier Provider
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final login = ref.watch(loginUseCaseProvider);
  final logout = ref.watch(logoutUseCaseProvider);
  return AuthNotifier(login, logout);
});
