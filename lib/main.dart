import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_clean_architecture/core/config/app_config.dart';
import 'package:riverpod_clean_architecture/core/config/firebase_options.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Print environment config (read from DART_DEFINES in xcconfig)
  debugPrint("🌍 Environment: ${EnvConfig.env}");
  debugPrint("🔗 Base URL: ${EnvConfig.apiBaseUrl}");
  debugPrint("📝 Logging: ${EnvConfig.enableLogging}");

  await Firebase.initializeApp(
    options: FirebaseEnvOptions.current,
  );
  debugPrint("🔥 Firebase API Key: ${FirebaseEnvOptions.current.apiKey}");
  debugPrint("🔥 Firebase App ID: ${FirebaseEnvOptions.current.appId}");

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
