import 'entities.dart';

abstract class AuthRepository {
  Future<UserEntity> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<String?> getToken();

  Future<String?> getRefreshToken();
}
