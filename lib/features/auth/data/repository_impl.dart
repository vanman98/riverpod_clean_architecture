import 'package:dartz/dartz.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failure.dart';
import '../../../core/crash/crash_reporter.dart';
import '../../../core/logging/app_logger.dart';
import '../../../core/network/network_info.dart';
import '../domain/entities.dart';
import '../domain/repository.dart';
import 'datasources.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      // 2. Log attempt
      AppLogger.info('Login attempt for: $email', tag: 'Auth');
      await CrashReporter.log('Login attempt for: $email');

      // 3. Call remote data source
      final model = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // 4. Save token locally
      if (model.token != null) {
        await localDataSource.saveToken(model.token!);
        AppLogger.info('Token saved successfully', tag: 'Auth');
      }

      // 5. Set user context in crash reporter
      await CrashReporter.setUserId(model.id);
      await CrashReporter.setCustomKey('user_email', email);

      AppLogger.info('Login successful for: $email', tag: 'Auth');
      await CrashReporter.log('Login successful');

      return Right(model.toEntity());
    } catch (e, stack) {
      // 6. Log error
      AppLogger.error(
        'Login failed for: $email',
        tag: 'Auth',
        error: e,
        stackTrace: stack,
      );

      // 7. Record to Crashlytics
      await CrashReporter.recordError(
        e,
        stack,
        reason: 'Login failed for: $email',
        fatal: false,
      );

      // 8. Convert to Failure
      final failure = ErrorHandler.handleError(e);
      return Left(failure);
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      AppLogger.info('Logout attempt', tag: 'Auth');
      await CrashReporter.log('User logout');

      // 1. Call remote logout (optional, may fail if offline)
      try {
        await remoteDataSource.logout();
      } catch (e) {
        // Ignore remote logout errors, still clear local data
        AppLogger.warning('Remote logout failed, clearing local data anyway',
            tag: 'Auth', error: e);
      }

      // 2. Clear local tokens
      await localDataSource.clearTokens();

      // 3. Clear crash reporter user context
      await CrashReporter.setUserId('');

      AppLogger.info('Logout successful', tag: 'Auth');
      return const Right(null);
    } catch (e, stack) {
      AppLogger.error(
        'Logout failed',
        tag: 'Auth',
        error: e,
        stackTrace: stack,
      );

      await CrashReporter.recordError(
        e,
        stack,
        reason: 'Logout failed',
        fatal: false,
      );

      final failure = ErrorHandler.handleError(e);
      return Left(failure);
    }
  }

  @override
  Future<String?> getToken() {
    return localDataSource.getToken();
  }

  @override
  Future<String?> getRefreshToken() {
    return localDataSource.getRefreshToken();
  }
}
