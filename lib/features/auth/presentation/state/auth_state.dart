import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_clean_architecture/features/auth/domain/entities.dart';
part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    @Default(false) bool isLoading,
    UserEntity? user,
    String? error,
  }) = _AuthState;

  bool get isLoggedIn => user != null;
}
