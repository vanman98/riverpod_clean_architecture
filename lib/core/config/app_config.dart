import 'package:riverpod_clean_architecture/core/config/native_config.dart';

class AppConfig {
  final String env; // dev / stg / prod
  final String apiBaseUrl;
  final bool enableLogging;

  const AppConfig({
    required this.env,
    required this.apiBaseUrl,
    required this.enableLogging,
  });

  bool get isDev => env == 'dev';
  bool get isStg => env == 'stg';
  bool get isProd => env == 'prod';
}

class EnvConfig {
  // Get it from --dart-define; if not passed, the default is dev.
  static String env = String.fromEnvironment('ENV', defaultValue: 'dev');
  static Future<void> init() async {
    env = await NativeConfig.appEnv;
    apiBaseUrl = await NativeConfig.baseUrl;
  }

  static String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://dev-api.yourdomain.com', // default base
  );

  static const enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );

  static AppConfig current = AppConfig(
    env: env,
    apiBaseUrl: apiBaseUrl,
    enableLogging: enableLogging,
  );
}
