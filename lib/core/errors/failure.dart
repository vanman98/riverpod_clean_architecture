import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  const factory Failure.network({
    required String message,
  }) = NetworkFailure;

  const factory Failure.cache({
    required String message,
  }) = CacheFailure;

  const factory Failure.validation({
    required String message,
    Map<String, String>? errors,
  }) = ValidationFailure;

  const factory Failure.unauthorized({
    required String message,
  }) = UnauthorizedFailure;

  const factory Failure.notFound({
    required String message,
  }) = NotFoundFailure;

  const factory Failure.unexpected({
    required String message,
  }) = UnexpectedFailure;
}

extension FailureX on Failure {
  /// Get raw error message
  String get errorMessage => when(
        server: (message, statusCode) => message,
        network: (message) => message,
        cache: (message) => message,
        validation: (message, errors) => message,
        unauthorized: (message) => message,
        notFound: (message) => message,
        unexpected: (message) => message,
      );

  /// Get user-friendly error message (Vietnamese)
  String get userMessage => when(
        server: (message, statusCode) {
          if (statusCode != null && statusCode >= 500) {
            return 'Server đang gặp sự cố. Vui lòng thử lại sau.';
          }
          return message.isNotEmpty
              ? message
              : 'Đã có lỗi từ server. Vui lòng thử lại.';
        },
        network: (message) =>
            'Không có kết nối internet. Vui lòng kiểm tra và thử lại.',
        unauthorized: (message) =>
            'Email hoặc mật khẩu không đúng. Vui lòng thử lại.',
        validation: (message, errors) {
          if (errors != null && errors.isNotEmpty) {
            return errors.values.join('\n');
          }
          return message.isNotEmpty ? message : 'Dữ liệu không hợp lệ.';
        },
        notFound: (message) =>
            message.isNotEmpty ? message : 'Tài khoản không tồn tại.',
        cache: (message) => 'Lỗi lưu trữ dữ liệu. Vui lòng thử lại.',
        unexpected: (message) => 'Đã có lỗi xảy ra. Vui lòng thử lại.',
      );

  /// Check if error can be retried
  bool get canRetry => when(
        server: (_, statusCode) =>
            statusCode == null || statusCode >= 500, // 5xx can retry
        network: (_) => true, // Network errors can retry
        cache: (_) => true, // Cache errors can retry
        validation: (_, __) => false, // Validation errors need user fix
        unauthorized: (_) => false, // Need re-login
        notFound: (_) => false, // Resource doesn't exist
        unexpected: (_) => true, // Unknown errors can retry
      );

  /// Get icon for UI
  IconData get icon => when(
        server: (_, __) => Icons.cloud_off,
        network: (_) => Icons.wifi_off,
        cache: (_) => Icons.storage,
        validation: (_, __) => Icons.error_outline,
        unauthorized: (_) => Icons.lock,
        notFound: (_) => Icons.search_off,
        unexpected: (_) => Icons.warning,
      );

  /// Get color for UI
  Color get color => when(
        server: (_, __) => Colors.red,
        network: (_) => Colors.orange,
        cache: (_) => Colors.purple,
        validation: (_, __) => Colors.amber,
        unauthorized: (_) => const Color(0xFFD32F2F),
        notFound: (_) => Colors.grey,
        unexpected: (_) => Colors.red,
      );
}
