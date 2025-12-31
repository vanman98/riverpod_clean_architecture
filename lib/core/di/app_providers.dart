import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_clean_architecture/core/config/app_config.dart';
import 'package:riverpod_clean_architecture/core/network/api_client.dart';
import 'package:riverpod_clean_architecture/core/network/connectivity_provider.dart';
import 'package:riverpod_clean_architecture/core/storage/secure_storage_service.dart';

final appConfigProvider = Provider<AppConfig>((ref) {
  return EnvConfig.current;
});

final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
});

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  final storage = ref.watch(flutterSecureStorageProvider);
  return SecureStorageServiceImpl(storage);
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final storageService = ref.watch(secureStorageServiceProvider);
  final networkInfo = ref.watch(networkInfoProvider);

  return ApiClient(
    baseUrl: config.apiBaseUrl,
    enableLogging: config.enableLogging,
    storageService: storageService,
    networkInfo: networkInfo,
  );
});
