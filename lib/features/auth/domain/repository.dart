import 'package:dartz/dartz.dart';
import '../../../core/errors/failure.dart';
import 'entities.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<String?> getToken();

  Future<String?> getRefreshToken();
}
