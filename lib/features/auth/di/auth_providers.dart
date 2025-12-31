import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_clean_architecture/core/di/app_providers.dart';
import 'package:riverpod_clean_architecture/core/network/connectivity_provider.dart';
import 'package:riverpod_clean_architecture/features/auth/data/datasources.dart';
import 'package:riverpod_clean_architecture/features/auth/data/repository_impl.dart';
import 'package:riverpod_clean_architecture/features/auth/domain/repository.dart';
import 'package:riverpod_clean_architecture/features/auth/domain/usecases.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = ref.watch(apiClientProvider);
  return AuthRemoteDataSourceImpl(client);
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return AuthLocalDataSourceImpl(secureStorage);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remote = ref.watch(authRemoteDataSourceProvider);
  final local = ref.watch(authLocalDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return AuthRepositoryImpl(
    remoteDataSource: remote,
    localDataSource: local,
    networkInfo: networkInfo,
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});
