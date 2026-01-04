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
          message: 'Connection timeout, please try again',
        );

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return const Failure.unexpected(
          message: 'Request was cancelled',
        );

      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        if (error.message?.contains('SocketException') ?? false) {
          return const Failure.network(
            message: 'No internet connection',
          );
        }
        return Failure.unexpected(
          message: error.message ?? 'Unknown error',
        );

      default:
        return const Failure.unexpected(
          message: 'An error occurred, please try again',
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
          message:
              message.isEmpty ? 'You do not have access permission' : message,
        );
      case 404:
        return Failure.notFound(message: message);
      case 500:
      case 502:
      case 503:
        return Failure.server(
          message: message.isEmpty
              ? 'Server error, please try again later'
              : message,
          statusCode: statusCode,
        );
      default:
        return Failure.server(
          message: message.isEmpty ? 'An error occurred' : message,
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
            'An error occurred';
      }
      return 'An error occurred';
    } catch (_) {
      return 'An error occurred';
    }
  }
}
