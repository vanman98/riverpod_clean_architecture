import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:riverpod_clean_architecture/core/usecases/usecase.dart';
import 'package:riverpod_clean_architecture/features/auth/di/auth_providers.dart';
import 'package:riverpod_clean_architecture/features/auth/domain/entities.dart';
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

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // final user = await _loginUseCase(
      //   LoginParams(email: email, password: password),
      // );
      state = state.copyWith(
          isLoading: false,
          user: UserEntity(id: '', name: '', email: '', token: ''));
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _logoutUseCase(const NoParams());
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
