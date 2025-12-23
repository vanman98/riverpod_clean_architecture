import 'package:firebase_core/firebase_core.dart';

import 'package:riverpod_clean_architecture/core/config/app_config.dart';
import 'package:riverpod_clean_architecture/firebase_options_dev.dart' as dev;
import 'package:riverpod_clean_architecture/firebase_options_prod.dart' as prod;

class FirebaseEnvOptions {
  static FirebaseOptions get current {
    switch (EnvConfig.env) {
      case 'prod':
        return prod.DefaultFirebaseOptions.currentPlatform;
      case 'stg':
      case 'dev':
      default:
        return dev.DefaultFirebaseOptions.currentPlatform;
    }
  }
}
