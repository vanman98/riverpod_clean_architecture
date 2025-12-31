import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_clean_architecture/l10n/app_localizations.dart';

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

  /// Get user-friendly error message with localization
  String localizedMessage(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return when(
      server: (message, statusCode) {
        if (statusCode != null && statusCode >= 500) {
          return l10n.errorServerBusy;
        }
        return message.isNotEmpty ? message : l10n.errorServerGeneric;
      },
      network: (message) => l10n.errorNetwork,
      unauthorized: (message) => l10n.errorUnauthorized,
      validation: (message, errors) {
        if (errors != null && errors.isNotEmpty) {
          return errors.values.join('\n');
        }
        return message.isNotEmpty ? message : l10n.errorValidation;
      },
      notFound: (message) => message.isNotEmpty ? message : l10n.errorNotFound,
      cache: (message) => l10n.errorCache,
      unexpected: (message) => l10n.errorUnexpected,
    );
  }

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
