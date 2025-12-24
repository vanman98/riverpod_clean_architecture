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
  // Read from DART_DEFINES (set in xcconfig files)
  static const String env =
      String.fromEnvironment('APP_ENV', defaultValue: 'dev');

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://dev-api.yourdomain.com',
  );

  static const bool enableLogging = bool.fromEnvironment(
    'ENABLE_LOGGING',
    defaultValue: true,
  );

  static const AppConfig current = AppConfig(
    env: env,
    apiBaseUrl: apiBaseUrl,
    enableLogging: enableLogging,
  );
}
