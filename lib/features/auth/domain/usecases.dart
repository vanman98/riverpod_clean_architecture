import 'package:riverpod_clean_architecture/core/usecases/usecase.dart';
import 'entities.dart';
import 'repository.dart';

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<UserEntity> call(LoginParams params) {
    return repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LogoutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<void> call(NoParams params) {
    return repository.logout();
  }
}
