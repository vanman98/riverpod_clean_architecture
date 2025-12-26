import 'package:riverpod_clean_architecture/core/network/api_client.dart';
import 'package:riverpod_clean_architecture/core/storage/secure_storage_service.dart';
import 'package:riverpod_clean_architecture/core/storage/storage_keys.dart';
import 'package:riverpod_clean_architecture/features/auth/data/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final json = await client.post(
      '/login',
      data: {
        'email': email,
        'password': password,
      },
    );

    final userJson = json['user'] as Map<String, dynamic>;
    final token = json['token'] as String?;
    final refreshToken = json['refreshToken'] as String?;

    return UserModel.fromJson(userJson).copyWith(
      token: token,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<void> logout() async {
    await client.post('/logout', data: {});
  }
}

abstract class AuthLocalDataSource {
  Future<void> saveToken(String token);
  Future<void> saveRefreshToken(String refreshToken);
  Future<String?> getToken();
  Future<String?> getRefreshToken();
  Future<void> clearTokens();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService secureStorage;

  AuthLocalDataSourceImpl(this.secureStorage);

  @override
  Future<void> saveToken(String token) async {
    await secureStorage.write(StorageKeys.accessToken, token);
  }

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    await secureStorage.write(StorageKeys.refreshToken, refreshToken);
  }

  @override
  Future<String?> getToken() async {
    return await secureStorage.read(StorageKeys.accessToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    return await secureStorage.read(StorageKeys.refreshToken);
  }

  @override
  Future<void> clearTokens() async {
    await secureStorage.delete(StorageKeys.accessToken);
    await secureStorage.delete(StorageKeys.refreshToken);
  }
}
