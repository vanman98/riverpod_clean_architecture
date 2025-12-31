import 'package:dartz/dartz.dart';
import 'package:riverpod_clean_architecture/core/errors/failure.dart';
import 'package:riverpod_clean_architecture/core/usecases/usecase.dart';
import 'entities.dart';
import 'repository.dart';

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}

class LoginUseCase
    implements UseCase<Either<Failure, UserEntity>, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) {
    return repository.login(
      email: params.email,
      password: params.password,
    );
  }
}

class LogoutUseCase implements UseCase<Either<Failure, void>, NoParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.logout();
  }
}

class GetTokenUseCase implements UseCase<String?, NoParams> {
  final AuthRepository repository;

  GetTokenUseCase(this.repository);

  @override
  Future<String?> call(NoParams params) {
    return repository.getToken();
  }
}

class GetRefreshTokenUseCase implements UseCase<String?, NoParams> {
  final AuthRepository repository;

  GetRefreshTokenUseCase(this.repository);

  @override
  Future<String?> call(NoParams params) {
    return repository.getRefreshToken();
  }
}
