import 'package:dio/dio.dart';
import 'package:riverpod_clean_architecture/core/storage/secure_storage_service.dart';
import 'package:riverpod_clean_architecture/core/storage/storage_keys.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService storageService;

  AuthInterceptor(this.storageService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await storageService.read(StorageKeys.accessToken);

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {}

    handler.next(err);
  }
}
