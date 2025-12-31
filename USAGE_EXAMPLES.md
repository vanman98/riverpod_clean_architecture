# Usage Examples - Critical Features

## 1. Error Handling System

### Using Failure in Repository

```dart
import 'package:dartz/dartz.dart'; // Install: dartz: ^0.10.1
import '../core/errors/failure.dart';
import '../core/errors/error_handler.dart';

class MyRepositoryImpl implements MyRepository {
  @override
  Future<Either<Failure, User>> getUser(String id) async {
    try {
      final response = await apiClient.get('/users/$id');
      final user = UserModel.fromJson(response).toEntity();
      return Right(user);
    } catch (e) {
      final failure = ErrorHandler.handleError(e);
      return Left(failure);
    }
  }
}
```

### Using in Notifier

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/errors/failure.dart';

@riverpod
class UserNotifier extends _$UserNotifier {
  @override
  AsyncValue<User?> build() => const AsyncValue.data(null);

  Future<void> loadUser(String id) async {
    state = const AsyncValue.loading();
    
    final result = await ref.read(userRepositoryProvider).getUser(id);
    
    result.fold(
      (failure) {
        state = AsyncValue.error(failure.errorMessage, StackTrace.current);
      },
      (user) {
        state = AsyncValue.data(user);
      },
    );
  }
}
```

## 2. Logging System

### Basic Logging

```dart
import '../core/logging/app_logger.dart';

class MyService {
  Future<void> doSomething() async {
    AppLogger.debug('Starting operation', tag: 'MyService');
    
    try {
      // Your code here
      AppLogger.info('Operation completed successfully', tag: 'MyService');
    } catch (e, stack) {
      AppLogger.error(
        'Operation failed',
        tag: 'MyService',
        error: e,
        stackTrace: stack,
      );
    }
  }
  
  Future<void> apiCall() async {
    AppLogger.network('GET /api/users');
    // API call
  }
}
```

## 3. Common Widgets

### CustomButton Usage

```dart
import '../shared/widgets/custom_button.dart';

CustomButton(
  text: 'Login',
  icon: Icons.login,
  onPressed: () => _handleLogin(),
  type: ButtonType.primary,
  isLoading: _isLoading,
  isExpanded: true,
)

// Outline button
CustomButton(
  text: 'Cancel',
  onPressed: () => Navigator.pop(context),
  type: ButtonType.outline,
)
```

### CustomTextField Usage

```dart
import '../shared/widgets/custom_text_field.dart';
import '../core/utils/validators.dart';

CustomTextField(
  label: 'Email',
  hint: 'Nhập email của bạn',
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  prefixIcon: Icons.email,
  validator: Validators.email,
  onChanged: (value) => setState(() {}),
)

CustomTextField(
  label: 'Mật khẩu',
  controller: _passwordController,
  obscureText: true,
  validator: Validators.password,
)
```

### Error & Loading Widgets

```dart
import '../shared/widgets/error_widget.dart';
import '../shared/widgets/loading_widget.dart';
import '../shared/widgets/empty_state_widget.dart';

// Error Widget
CustomErrorWidget(
  message: 'Không thể tải dữ liệu',
  onRetry: () => _loadData(),
)

// Loading Widget
LoadingWidget(message: 'Đang tải...')

// Loading Overlay
LoadingOverlay(
  isLoading: _isLoading,
  message: 'Đang xử lý...',
  child: YourContent(),
)

// Empty State
EmptyStateWidget(
  message: 'Chưa có dữ liệu',
  description: 'Bắt đầu thêm mới ngay',
  icon: Icons.inbox,
  onAction: () => _addNew(),
  actionText: 'Thêm mới',
)
```

### AsyncValue with Widgets

```dart
final userState = ref.watch(userNotifierProvider);

userState.when(
  data: (user) => UserProfile(user: user),
  loading: () => const LoadingWidget(),
  error: (error, stack) => CustomErrorWidget(
    message: error.toString(),
    onRetry: () => ref.refresh(userNotifierProvider),
  ),
)
```

## 4. Network Connectivity

### Setup in App

```dart
import '../shared/widgets/connectivity_banner.dart';

@override
Widget build(BuildContext context) {
  return MaterialApp(
    home: ConnectivityBanner(
      child: YourHomePage(),
    ),
  );
}
```

### Check Connectivity in Code

```dart
import '../core/network/connectivity_provider.dart';

class MyPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnectedAsync = ref.watch(isConnectedProvider);
    
    return isConnectedAsync.when(
      data: (isConnected) {
        if (!isConnected) {
          return const Center(
            child: Text('Không có kết nối internet'),
          );
        }
        return YourContent();
      },
      loading: () => const LoadingWidget(),
      error: (_, __) => YourContent(),
    );
  }
  
  Future<void> makeApiCall() async {
    final networkInfo = ref.read(networkInfoProvider);
    final isConnected = await networkInfo.isConnected;
    
    if (!isConnected) {
      // Show error message
      return;
    }
    
    // Make API call
  }
}
```

### Listen to Connectivity Changes

```dart
@override
void initState() {
  super.initState();
  
  final networkInfo = ref.read(networkInfoProvider);
  networkInfo.onConnectivityChanged.listen((isConnected) {
    if (isConnected) {
      AppLogger.info('Internet connected');
      // Retry failed requests
    } else {
      AppLogger.warning('Internet disconnected');
      // Show offline UI
    }
  });
}
```

## 5. Crash Reporter

### Basic Usage

```dart
import '../core/crash/crash_reporter.dart';

// Log custom message
await CrashReporter.log('User started checkout process');

// Set user ID (call after login)
await CrashReporter.setUserId(user.id);

// Set custom keys
await CrashReporter.setCustomKey('user_tier', 'premium');
await CrashReporter.setCustomKey('cart_items', 5);

// Record non-fatal error
try {
  await riskyOperation();
} catch (e, stack) {
  await CrashReporter.recordError(
    e,
    stack,
    reason: 'Failed to process payment',
    fatal: false,
  );
}
```

### In Repository

```dart
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<UserEntity> login({required String email, required String password}) async {
    try {
      await CrashReporter.log('Login attempt for: $email');
      
      final model = await remoteDataSource.login(email: email, password: password);
      
      if (model.token != null) {
        await localDataSource.saveToken(model.token!);
        await CrashReporter.setUserId(model.id);
        await CrashReporter.log('Login successful');
      }
      
      return model.toEntity();
    } catch (e, stack) {
      await CrashReporter.recordError(
        e,
        stack,
        reason: 'Login failed for: $email',
        fatal: false,
      );
      rethrow;
    }
  }
}
```

## Complete Example: Feature Implementation

```dart
// repository_impl.dart
import 'package:dartz/dartz.dart';
import '../core/errors/failure.dart';
import '../core/errors/error_handler.dart';
import '../core/logging/app_logger.dart';
import '../core/crash/crash_reporter.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ApiClient apiClient;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      // Check network
      final isConnected = await networkInfo.isConnected;
      if (!isConnected) {
        return const Left(Failure.network(message: 'Không có kết nối internet'));
      }

      AppLogger.network('GET /products', tag: 'ProductRepo');
      await CrashReporter.log('Fetching products');

      final response = await apiClient.get('/products');
      final products = (response['data'] as List)
          .map((json) => ProductModel.fromJson(json).toEntity())
          .toList();

      AppLogger.info('Loaded ${products.length} products', tag: 'ProductRepo');
      return Right(products);
      
    } catch (e, stack) {
      AppLogger.error('Failed to load products', tag: 'ProductRepo', error: e, stackTrace: stack);
      await CrashReporter.recordError(e, stack, reason: 'Failed to fetch products');
      
      final failure = ErrorHandler.handleError(e);
      return Left(failure);
    }
  }
}

// notifier.dart
@riverpod
class ProductList extends _$ProductList {
  @override
  Future<List<Product>> build() async {
    return _loadProducts();
  }

  Future<List<Product>> _loadProducts() async {
    final result = await ref.read(productRepositoryProvider).getProducts();
    
    return result.fold(
      (failure) => throw failure.errorMessage,
      (products) => products,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadProducts());
  }
}

// page.dart
class ProductListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsState = ref.watch(productListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: ConnectivityBanner(
        child: productsState.when(
          data: (products) {
            if (products.isEmpty) {
              return EmptyStateWidget(
                message: 'Chưa có sản phẩm',
                icon: Icons.shopping_bag_outlined,
              );
            }
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) => ProductCard(products[index]),
            );
          },
          loading: () => const LoadingWidget(message: 'Đang tải sản phẩm...'),
          error: (error, _) => CustomErrorWidget(
            message: error.toString(),
            onRetry: () => ref.refresh(productListProvider),
          ),
        ),
      ),
    );
  }
}
```

## Notes

- **Error Handling**: Always use `Either<Failure, T>` in repositories
- **Logging**: Use appropriate log levels (debug/info/warning/error)
- **Crash Reporter**: Only enabled in release mode, disabled in debug
- **Network Check**: Always check before making API calls
- **Widgets**: Reuse common widgets for consistency
