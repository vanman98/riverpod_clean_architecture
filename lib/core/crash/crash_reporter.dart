import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import '../logging/app_logger.dart';

class CrashReporter {
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  static Future<void> initialize() async {
    if (kDebugMode) {
      await _crashlytics.setCrashlyticsCollectionEnabled(false);
      AppLogger.info('Crashlytics disabled in debug mode', tag: 'CRASH');
    } else {
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
      AppLogger.info('Crashlytics enabled in release mode', tag: 'CRASH');
    }

    FlutterError.onError = (errorDetails) {
      AppLogger.error(
        'Flutter Error',
        tag: 'CRASH',
        error: errorDetails.exception,
        stackTrace: errorDetails.stack,
      );
      _crashlytics.recordFlutterFatalError(errorDetails);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      AppLogger.error(
        'Platform Error',
        tag: 'CRASH',
        error: error,
        stackTrace: stack,
      );
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  static Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    String? reason,
    bool fatal = false,
  }) async {
    AppLogger.error(
      reason ?? 'Recorded Error',
      tag: 'CRASH',
      error: exception,
      stackTrace: stack,
    );

    await _crashlytics.recordError(
      exception,
      stack,
      reason: reason,
      fatal: fatal,
    );
  }

  static Future<void> log(String message) async {
    AppLogger.info(message, tag: 'CRASH');
    await _crashlytics.log(message);
  }

  static Future<void> setUserId(String userId) async {
    AppLogger.info('Setting user ID: $userId', tag: 'CRASH');
    await _crashlytics.setUserIdentifier(userId);
  }

  static Future<void> setCustomKey(String key, dynamic value) async {
    AppLogger.debug('Setting custom key: $key = $value', tag: 'CRASH');
    await _crashlytics.setCustomKey(key, value);
  }
}
