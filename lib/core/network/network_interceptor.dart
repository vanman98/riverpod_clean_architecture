import 'package:dio/dio.dart';
import 'package:riverpod_clean_architecture/core/errors/exceptions.dart';
import 'package:riverpod_clean_architecture/core/logging/app_logger.dart';
import 'package:riverpod_clean_architecture/core/network/network_info.dart';

/// Interceptor tự động check network trước MỌI API call
class NetworkInterceptor extends Interceptor {
  final NetworkInfo networkInfo;

  NetworkInterceptor(this.networkInfo);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isConnected = await networkInfo.isConnected;

    if (!isConnected) {
      AppLogger.warning(
        'Request blocked: No internet connection',
        tag: 'NETWORK',
      );

      return handler.reject(
        DioException(
          requestOptions: options,
          error: NetworkException('Không có kết nối internet'),
          type: DioExceptionType.connectionError,
        ),
      );
    }

    return handler.next(options);
  }
}
