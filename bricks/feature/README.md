# Feature Brick

A Mason brick to generate a new feature with Clean Architecture structure.

## Structure

```
feature_name/
├── data/
│   ├── datasources.dart
│   ├── repository_impl.dart
│   └── feature_name_model.dart
├── di/
│   └── feature_name_providers.dart
├── domain/
│   ├── entities.dart
│   ├── repository.dart
│   └── usecases.dart
└── presentation/
    ├── state/
    │   └── feature_name_notifier.dart
    └── feature_name_page.dart
```

## Usage
# 1. Cài Mason CLI (chỉ làm 1 lần)
dart pub global activate mason_cli
# 2. Khởi tạo Mason (chỉ làm 1 lần)
cd "/Users/macboockm1/Documents/app business/etsy_seller_companion"
mason init
# 3. Thêm brick vào project (chỉ làm 1 lần)
mason add feature --path bricks/feature
# 4. Tạo feature mới (VD: product)
mason make feature --feature_name product -o lib/features
# 5. Generate code
flutter pub run build_runner build --delete-conflicting-outputs

## After Generation

1. Run code generation:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. Fill in the TODOs in the generated files
3. Import the feature in your app
