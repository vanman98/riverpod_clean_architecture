import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_clean_architecture/core/config/app_config.dart';
import 'package:riverpod_clean_architecture/core/network/api_client.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return EnvConfig.current;
});
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);

  return ApiClient(
    baseUrl: config.apiBaseUrl,
    enableLogging: config.enableLogging,
  );
});
