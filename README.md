# Riverpod Clean Architecture

A Flutter project template implementing Clean Architecture with Riverpod state management, designed for scalable and maintainable mobile applications.

## 📋 Table of Contents

- [Architecture Overview](#-architecture-overview)
- [Tech Stack](#-tech-stack)
- [Project Setup](#-project-setup)
- [Running the Application](#-running-the-application)
- [Adding a New Feature](#-adding-a-new-feature)
- [Project Structure](#-project-structure)
- [Additional Documentation](#-additional-documentation)

## 🏗️ Architecture Overview

This project follows **Clean Architecture** principles with three main layers:

```
┌─────────────────────────────────────────┐
│         Presentation Layer              │
│  (UI, State Management, Notifiers)      │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│           Domain Layer                  │
│  (Entities, UseCases, Repositories)     │
└─────────────────────────────────────────┘
                  ↓
┌─────────────────────────────────────────┐
│            Data Layer                   │
│  (Models, DataSources, Repository Impl) │
└─────────────────────────────────────────┘
```

### Key Principles

- **Separation of Concerns**: Each layer has distinct responsibilities
- **Dependency Inversion**: Higher layers don't depend on lower layers
- **Testability**: Business logic is independent of framework and UI
- **Scalability**: Easy to add new features without affecting existing code

## 🛠️ Tech Stack

### Core
- **Flutter SDK**: ^3.5.4
- **Dart**: ^3.5.4

### State Management & DI
- **flutter_riverpod**: ^3.0.3 - State management
- **riverpod_annotation**: ^3.0.3 - Code generation for providers
- **riverpod_generator**: ^3.0.3 - Generator for Riverpod

### Networking
- **dio**: ^5.4.0 - HTTP client
- **retrofit**: ^4.0.3 - Type-safe REST client
- **retrofit_generator**: ^10.2.0 - Code generation for API clients

### Data Serialization
- **json_annotation**: ^4.9.0 - JSON serialization annotations
- **json_serializable**: ^6.7.1 - JSON serialization generator
- **freezed**: ^3.2.3 - Code generation for immutable classes
- **freezed_annotation**: ^3.1.0

### Navigation
- **go_router**: ^14.2.0 - Declarative routing

### Storage
- **flutter_secure_storage**: ^9.0.0 - Secure storage for sensitive data
- **shared_preferences**: ^2.2.0 - Simple key-value storage

### Firebase
- **firebase_core**: ^4.3.0 - Firebase core functionality
- **firebase_crashlytics**: ^5.0.6 - Crash reporting

### Utilities
- **cached_network_image**: ^3.3.0 - Image caching
- **flutter_screenutil**: ^5.9.3 - Responsive UI
- **dartz**: ^0.10.1 - Functional programming (Either, Option)
- **intl**: Internationalization and localization

### Development Tools
- **build_runner**: ^2.4.8 - Code generation runner
- **mason_cli**: Feature scaffolding
- **flutter_lints**: ^4.0.0 - Linting rules

## 🚀 Project Setup

### Prerequisites

1. **Flutter SDK** (3.5.4 or higher)
   ```bash
   flutter --version
   ```

2. **Dart SDK** (3.5.4 or higher)
   ```bash
   dart --version
   ```

3. **Mason CLI** (for feature generation)
   ```bash
   dart pub global activate mason_cli
   ```

4. **Firebase CLI** (optional, for Firebase configuration)
   ```bash
   npm install -g firebase-tools
   ```

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd riverpod_clean_architecture
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Initialize Mason**
   ```bash
   mason init
   mason add feature --path bricks/feature
   ```

4. **Generate code**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Configure Firebase** (if needed)
   - Add your `google-services.json` (Android) to `android/app/`
   - Add your `GoogleService-Info.plist` (iOS) to `ios/Runner/`
   - Update Firebase options in `lib/firebase_options_dev.dart` and `lib/firebase_options_prod.dart`

6. **Update Environment Variables**
   - Edit `Makefile` and update API URLs for your backend:
     - `API_BASE_URL` for dev, staging, and production environments

## ▶️ Running the Application

### Method 1: Using Makefile (Recommended)

```bash
# Development environment
make dev

# Staging environment
make stg

# Production environment
make prod

# Clean build files
make clean

# View all available commands
make help
```

### Method 2: Using Shell Scripts

```bash
# Development
./scripts/run_dev.sh

# Staging
./scripts/run_stg.sh

# Production
./scripts/run_prod.sh

# With additional Flutter parameters
./scripts/run_dev.sh -d <device-id>
./scripts/run_dev.sh --release
```

### Method 3: Direct Flutter Command

```bash
# Development
flutter run \
  --dart-define=APP_ENV=dev \
  --dart-define=API_BASE_URL=https://dev-api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=true

# Production
flutter run \
  --dart-define=APP_ENV=prod \
  --dart-define=API_BASE_URL=https://api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=false
```

### Method 4: VSCode/IDE Launch Configurations

Use the pre-configured launch configurations in `.vscode/launch.json`:
- **Dev**: Development environment
- **Stg**: Staging environment
- **Prod**: Production environment

Press `F5` to run with the selected configuration.

## 🎯 Adding a New Feature

This project uses **Mason** to generate feature scaffolding following Clean Architecture.

### Step-by-Step Guide

#### 1. Generate Feature Structure

```bash
# Generate a new feature (e.g., "product")
mason make feature --feature_name product -o lib/features

# Or interactively
mason make feature -o lib/features
```

This creates the following structure:

```
lib/features/product/
├── data/
│   ├── datasources.dart           # Remote & Local data sources
│   ├── repository_impl.dart       # Repository implementation
│   └── product_model.dart         # Data models with JSON serialization
├── di/
│   └── product_providers.dart     # Riverpod providers for DI
├── domain/
│   ├── entities.dart              # Business entities
│   ├── repository.dart            # Repository interface
│   └── usecases.dart              # Business logic use cases
└── presentation/
    ├── state/
    │   └── product_notifier.dart  # State management with Riverpod
    └── product_page.dart          # UI widgets
```

#### 2. Understand the Generated Structure

##### **Data Layer** (`data/`)
- **Models**: Define data structures with JSON serialization
  ```dart
  @freezed
  class ProductModel with _$ProductModel {
    factory ProductModel({
      required String id,
      required String name,
    }) = _ProductModel;
    
    factory ProductModel.fromJson(Map<String, dynamic> json) => 
        _$ProductModelFromJson(json);
  }
  ```

- **Data Sources**: Handle API calls and local storage
  ```dart
  abstract class ProductRemoteDataSource {
    Future<ProductModel> getProduct(String id);
  }
  ```

- **Repository Implementation**: Implements domain repository
  ```dart
  class ProductRepositoryImpl implements ProductRepository {
    final ProductRemoteDataSource remoteDataSource;
    
    @override
    Future<Either<Failure, Product>> getProduct(String id) async {
      try {
        final model = await remoteDataSource.getProduct(id);
        return Right(model.toEntity());
      } catch (e) {
        return Left(ServerFailure());
      }
    }
  }
  ```

##### **Domain Layer** (`domain/`)
- **Entities**: Pure business objects (no framework dependencies)
  ```dart
  class Product {
    final String id;
    final String name;
    
    Product({required this.id, required this.name});
  }
  ```

- **Repository Interface**: Defines contracts for data operations
  ```dart
  abstract class ProductRepository {
    Future<Either<Failure, Product>> getProduct(String id);
  }
  ```

- **Use Cases**: Single-purpose business logic
  ```dart
  class GetProduct extends UseCase<Product, String> {
    final ProductRepository repository;
    
    @override
    Future<Either<Failure, Product>> call(String params) {
      return repository.getProduct(params);
    }
  }
  ```

##### **Presentation Layer** (`presentation/`)
- **State Notifier**: Manages UI state with Riverpod
  ```dart
  @riverpod
  class ProductNotifier extends _$ProductNotifier {
    @override
    AsyncValue<Product?> build() => const AsyncValue.data(null);
    
    Future<void> loadProduct(String id) async {
      state = const AsyncValue.loading();
      final result = await ref.read(getProductProvider).call(id);
      state = result.fold(
        (failure) => AsyncValue.error(failure, StackTrace.current),
        (product) => AsyncValue.data(product),
      );
    }
  }
  ```

- **UI Page**: Flutter widgets consuming the state
  ```dart
  class ProductPage extends ConsumerWidget {
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      final state = ref.watch(productNotifierProvider);
      
      return state.when(
        data: (product) => Text(product?.name ?? 'No product'),
        loading: () => CircularProgressIndicator(),
        error: (error, stack) => Text('Error: $error'),
      );
    }
  }
  ```

##### **Dependency Injection** (`di/`)
- **Providers**: Wire up dependencies
  ```dart
  @riverpod
  ProductRepository productRepository(ProductRepositoryRef ref) {
    return ProductRepositoryImpl(
      remoteDataSource: ref.watch(productRemoteDataSourceProvider),
    );
  }
  
  @riverpod
  GetProduct getProduct(GetProductRef ref) {
    return GetProduct(ref.watch(productRepositoryProvider));
  }
  ```

#### 3. Run Code Generation

After creating or modifying files with annotations, run:

```bash
# Generate all code
flutter pub run build_runner build --delete-conflicting-outputs

# Or watch for changes (auto-regenerate)
flutter pub run build_runner watch --delete-conflicting-outputs
```

This generates:
- `.g.dart` files for JSON serialization
- `.freezed.dart` files for immutable classes
- Riverpod provider implementations

#### 4. Implement Your Feature

Fill in the TODOs in generated files:

1. **Define your API endpoints** in `data/datasources.dart`
2. **Create models** matching your API response in `data/product_model.dart`
3. **Implement repository** logic in `data/repository_impl.dart`
4. **Define entities** in `domain/entities.dart`
5. **Create use cases** for business logic in `domain/usecases.dart`
6. **Build UI** in `presentation/product_page.dart`
7. **Manage state** in `presentation/state/product_notifier.dart`

#### 5. Add Navigation Route

Add your new page to the router in `lib/app/router/app_router.dart`:

```dart
GoRoute(
  path: '/product/:id',
  name: 'product',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return ProductPage(productId: id);
  },
),
```

#### 6. Test Your Feature

```bash
# Run tests
flutter test

# Run specific test file
flutter test test/features/product/domain/usecases/get_product_test.dart
```

### Best Practices When Adding Features

✅ **DO**:
- Keep use cases focused on a single responsibility
- Use `Either` from dartz for error handling
- Implement proper error types (extend `Failure`)
- Add loading states in your notifiers
- Write unit tests for domain layer
- Use freezed for immutable state classes
- Follow the existing naming conventions

❌ **DON'T**:
- Mix business logic in UI widgets
- Make direct API calls from presentation layer
- Skip code generation after changes
- Hardcode strings (use localization)
- Forget to handle error states
- Create god classes with too many responsibilities

## 📁 Project Structure

```
lib/
├── app/                          # Application-level configuration
│   ├── router/                   # Navigation and routing
│   └── shell/                    # App shell/scaffold
├── core/                         # Core utilities and shared code
│   ├── config/                   # App configuration
│   ├── crash/                    # Crash reporting
│   ├── di/                       # Global dependency injection
│   ├── errors/                   # Error handling and failures
│   ├── logging/                  # Logging utilities
│   ├── network/                  # Network configuration (Dio, interceptors)
│   ├── storage/                  # Storage interfaces
│   ├── usecases/                 # Base use case classes
│   └── utils/                    # Utility functions
├── features/                     # Feature modules
│   ├── auth/                     # Authentication feature
│   │   ├── data/
│   │   ├── domain/
│   │   ├── presentation/
│   │   └── di/
│   ├── home/                     # Home feature
│   ├── settings/                 # Settings feature
│   └── transactions/             # Transactions feature
├── shared/                       # Shared widgets and components
│   └── widgets/
├── l10n/                        # Localization files
├── firebase_options_dev.dart    # Firebase config for dev
├── firebase_options_prod.dart   # Firebase config for prod
└── main.dart                    # Application entry point
```

## 📚 Additional Documentation

- **[RUN_INSTRUCTIONS.md](RUN_INSTRUCTIONS.md)**: Detailed instructions for running the app in different environments
- **[L10N_GUIDE.md](L10N_GUIDE.md)**: Internationalization and localization guide
- **[STORAGE_USAGE.md](STORAGE_USAGE.md)**: Storage implementation guide (Secure Storage, SharedPreferences)
- **[USAGE_EXAMPLES.md](USAGE_EXAMPLES.md)**: Code examples and common patterns
- **[FAILURE_SYSTEM_DEMO.md](FAILURE_SYSTEM_DEMO.md)**: Error handling system documentation
- **[IOS_BUILD_GUIDE.md](IOS_BUILD_GUIDE.md)**: iOS-specific build instructions

## 🤝 Contributing

1. Follow the Clean Architecture principles
2. Use Mason to generate new features
3. Run code generation after changes
4. Write tests for business logic
5. Follow the existing code style
6. Update documentation when needed

## 📝 License

This project is private and not licensed for public use.

---

**Happy Coding! 🚀**
