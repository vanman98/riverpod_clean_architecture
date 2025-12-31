import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
}

class AppLogger {
  static const String _defaultTag = 'APP';

  static void debug(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.debug,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void info(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.info,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void warning(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.warning,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void network(
    String message, {
    Map<String, dynamic>? data,
  }) {
    if (kDebugMode) {
      debug('🌐 NETWORK: $message', tag: 'NETWORK');
      if (data != null) {
        debug('Data: $data', tag: 'NETWORK');
      }
    }
  }

  static void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (kDebugMode) {
      final logTag = tag ?? _defaultTag;
      final emoji = _getEmoji(level);
      final timestamp = DateTime.now().toIso8601String();

      final logMessage = StringBuffer();
      logMessage.writeln('$emoji [$logTag] $timestamp');
      logMessage.writeln(message);

      if (error != null) {
        logMessage.writeln('Error: $error');
      }

      if (stackTrace != null) {
        logMessage.writeln('StackTrace:\n$stackTrace');
      }

      developer.log(
        logMessage.toString(),
        name: logTag,
        level: _getLevel(level),
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  static String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🔍';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
    }
  }

  static int _getLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
    }
  }
}
