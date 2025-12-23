import '../domain/entities.dart';
import '../domain/repository.dart';
import 'datasources.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final model = await remoteDataSource.login(
      email: email,
      password: password,
    );

    return model.toEntity();
  }

  @override
  Future<void> logout() {
    return remoteDataSource.logout();
  }
}
