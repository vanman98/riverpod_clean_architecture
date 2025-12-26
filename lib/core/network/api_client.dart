import 'package:dio/dio.dart';
import 'package:riverpod_clean_architecture/core/network/auth_interceptor.dart';
import 'package:riverpod_clean_architecture/core/storage/secure_storage_service.dart';

class ApiClient {
  final Dio _dio;

  ApiClient({
    required String baseUrl,
    required bool enableLogging,
    SecureStorageService? storageService,
  }) : _dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            connectTimeout: const Duration(seconds: 15),
            receiveTimeout: const Duration(seconds: 15),
          ),
        ) {
    if (storageService != null) {
      _dio.interceptors.add(AuthInterceptor(storageService));
    }

    if (enableLogging) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
        ),
      );
    }
  }

  Dio get rawDio => _dio;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    final data = response.data;
    if (data is Map<String, dynamic>) return data;
    return {'data': data};
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    final response = await _dio.post(path, data: data);
    final body = response.data;
    if (body is Map<String, dynamic>) return body;
    return {'data': body};
  }
}
