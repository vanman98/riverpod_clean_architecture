import '../domain/entities.dart';
import '../domain/repository.dart';
import 'datasources.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final model = await remoteDataSource.login(
      email: email,
      password: password,
    );

    if (model.token != null) {
      await localDataSource.saveToken(model.token!);
    }

    return model.toEntity();
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.clearTokens();
  }

  @override
  Future<String?> getToken() {
    return localDataSource.getToken();
  }

  @override
  Future<String?> getRefreshToken() {
    return localDataSource.getRefreshToken();
  }
}
