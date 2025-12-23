import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_clean_architecture/core/config/app_config.dart';
import 'package:riverpod_clean_architecture/core/config/firebase_options.dart';

import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.init();
  await Firebase.initializeApp(
    options: FirebaseEnvOptions.current,
  );
  debugPrint("API KEY FIREBASE ${FirebaseEnvOptions.current.apiKey}");
  debugPrint("APP ID FIREBASE ${FirebaseEnvOptions.current.appId}");
  debugPrint("BASE URL ${EnvConfig.apiBaseUrl}");
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
