import 'package:riverpod_clean_architecture/core/network/api_client.dart';
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

    return UserModel.fromJson(userJson);
  }

  @override
  Future<void> logout() async {
    await client.post('/logout', data: {});
  }
}
