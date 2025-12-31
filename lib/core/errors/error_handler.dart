import 'package:dio/dio.dart';
import 'exceptions.dart';
import 'failure.dart';

class ErrorHandler {
  static Failure handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is ServerException) {
      return Failure.server(
        message: error.message,
        statusCode: error.statusCode,
      );
    } else if (error is NetworkException) {
      return Failure.network(message: error.message);
    } else if (error is CacheException) {
      return Failure.cache(message: error.message);
    } else if (error is UnauthorizedException) {
      return Failure.unauthorized(message: error.message);
    } else if (error is ValidationException) {
      return Failure.validation(
        message: error.message,
        errors: error.errors,
      );
    } else if (error is NotFoundException) {
      return Failure.notFound(message: error.message);
    } else {
      return Failure.unexpected(
        message: error.toString(),
      );
    }
  }

  static Failure _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const Failure.network(
          message: 'Kết nối timeout, vui lòng thử lại',
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return const Failure.unexpected(
          message: 'Request đã bị hủy',
        );

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return const Failure.network(
            message: 'Không có kết nối internet',
          );
        }
        return Failure.unexpected(
          message: error.message ?? 'Lỗi không xác định',
        );

      default:
        return const Failure.unexpected(
          message: 'Đã có lỗi xảy ra, vui lòng thử lại',
        );
    }
  }

  static Failure _handleResponseError(Response? response) {
    final statusCode = response?.statusCode ?? 0;
    final message = _extractErrorMessage(response);

    switch (statusCode) {
      case 400:
        return Failure.validation(message: message);
      case 401:
        return Failure.unauthorized(message: message);
      case 403:
        return Failure.unauthorized(
          message: message.isEmpty ? 'Bạn không có quyền truy cập' : message,
        );
      case 404:
        return Failure.notFound(message: message);
      case 500:
      case 502:
      case 503:
        return Failure.server(
          message:
              message.isEmpty ? 'Lỗi server, vui lòng thử lại sau' : message,
          statusCode: statusCode,
        );
      default:
        return Failure.server(
          message: message.isEmpty ? 'Đã có lỗi xảy ra' : message,
          statusCode: statusCode,
        );
    }
  }

  static String _extractErrorMessage(Response? response) {
    try {
      final data = response?.data;
      if (data is Map<String, dynamic>) {
        return data['message'] ??
            data['error'] ??
            data['msg'] ??
            'Đã có lỗi xảy ra';
      }
      return 'Đã có lỗi xảy ra';
    } catch (_) {
      return 'Đã có lỗi xảy ra';
    }
  }
}
