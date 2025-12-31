import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_clean_architecture/core/config/app_config.dart';
import 'package:riverpod_clean_architecture/core/config/firebase_options.dart';
import 'package:riverpod_clean_architecture/core/crash/crash_reporter.dart';
import 'package:riverpod_clean_architecture/core/logging/app_logger.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info("🌍 Environment: ${EnvConfig.env}", tag: 'MAIN');
  AppLogger.info("🔗 Base URL: ${EnvConfig.apiBaseUrl}", tag: 'MAIN');
  AppLogger.info("📝 Logging: ${EnvConfig.enableLogging}", tag: 'MAIN');

  await Firebase.initializeApp(
    options: FirebaseEnvOptions.current,
  );
  AppLogger.info("🔥 Firebase initialized", tag: 'MAIN');

  await CrashReporter.initialize();
  AppLogger.info("💥 Crash Reporter initialized", tag: 'MAIN');

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
