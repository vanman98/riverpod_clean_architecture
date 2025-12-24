# Hướng dẫn Build App (iOS & Android) với Nhiều Environments

## 📋 Tổng quan

Project này đã được cấu hình để build app (iOS & Android) với 3 môi trường khác nhau:
- **DEV** - Development environment
- **STG** - Staging environment  
- **PROD** - Production environment

**Lưu ý**: Android và iOS đều đã được config đầy đủ 3 flavors.

## 🎯 Cách hoạt động

### 1. Run app từ Terminal (Khuyến nghị)

Sử dụng `flutter run` với `--dart-define` để truyền biến config:

#### **Chạy DEV**
```bash
make dev
```
Hoặc:
```bash
flutter run \
  --dart-define=APP_ENV=dev \
  --dart-define=API_BASE_URL=https://dev-api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=true
```

#### **Chạy STG**
```bash
make stg
```
Hoặc:
```bash
flutter run \
  --dart-define=APP_ENV=stg \
  --dart-define=API_BASE_URL=https://stg-api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=true
```

#### **Chạy PROD**
```bash
make prod
```
Hoặc:
```bash
flutter run \
  --dart-define=APP_ENV=prod \
  --dart-define=API_BASE_URL=https://api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=false
```

### 2. Build IPA cho từng environment

#### **Build DEV**
```bash
flutter build ipa \
  --dart-define=APP_ENV=dev \
  --dart-define=API_BASE_URL=https://dev-api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=true \
  --export-options-plist=ios/ExportOptions.plist
```

#### **Build STG**
```bash
flutter build ipa \
  --dart-define=APP_ENV=stg \
  --dart-define=API_BASE_URL=https://stg-api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=true \
  --export-options-plist=ios/ExportOptions.plist
```

#### **Build PROD**
```bash
flutter build ipa \
  --dart-define=APP_ENV=prod \
  --dart-define=API_BASE_URL=https://api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=false \
  --export-options-plist=ios/ExportOptions.plist
```

### 3. Build APK/AAB cho Android

#### **Build APK cho Dev**
```bash
flutter build apk \
  --flavor dev \
  --dart-define=APP_ENV=dev \
  --dart-define=API_BASE_URL=https://dev-api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=true
```

#### **Build APK cho Stg**
```bash
flutter build apk \
  --flavor stg \
  --dart-define=APP_ENV=stg \
  --dart-define=API_BASE_URL=https://stg-api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=true
```

#### **Build APK cho Prod**
```bash
flutter build apk \
  --flavor prod \
  --dart-define=APP_ENV=prod \
  --dart-define=API_BASE_URL=https://api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=false
```

#### **Build AAB (App Bundle) cho Play Store**
```bash
flutter build appbundle \
  --flavor prod \
  --dart-define=APP_ENV=prod \
  --dart-define=API_BASE_URL=https://api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=false \
  --release
```

### 4. Build từ Xcode (Nếu cần)

Nếu bạn muốn build trực tiếp từ Xcode:

1. **Mở project**:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Chọn Scheme** tương ứng:
   - **Debug-dev** → Development
   - **Debug-stg** → Staging
   - **Debug-prod** → Production

3. **Build** (Cmd + B) hoặc **Run** (Cmd + R)

**⚠️ Lưu ý**: Khi build từ Xcode, bạn KHÔNG thể truyền dart-define variables. Do đó:
- App sẽ sử dụng giá trị default trong code
- Nên ưu tiên dùng `flutter run` hoặc `flutter build` từ terminal

## 📁 Cấu trúc Files Quan trọng

### iOS Configuration Files

```
ios/
├── Flutter/
│   ├── Debug-dev.xcconfig       # Dev config
│   ├── Debug-stg.xcconfig       # Stg config
│   ├── Debug-prod.xcconfig      # Prod config
│   ├── Release-dev.xcconfig
│   ├── Release-stg.xcconfig
│   └── Release-prod.xcconfig
├── Runner/
│   ├── Firebase/
│   │   ├── GoogleService-Info-Dev.plist
│   │   └── GoogleService-Info-Prod.plist
│   └── Info.plist
└── Runner.xcodeproj/
    └── project.pbxproj          # Xcode project config
```

### Android Configuration Files

```
android/
├── app/
│   ├── build.gradle            # Product flavors: dev, stg, prod
│   └── google-services.json    # Firebase config (auto-selected)
└── settings.gradle             # Kotlin version
```

### Scripts để Run

```
.
├── Makefile                     # Commands: make dev, make stg, make prod
└── scripts/
    ├── run_dev.sh              # ./scripts/run_dev.sh
    ├── run_stg.sh              # ./scripts/run_stg.sh
    └── run_prod.sh             # ./scripts/run_prod.sh
```

## 🔧 Chi tiết Technical

### 1. Xcode Run Script đã được đơn giản hóa

File: `ios/Runner.xcodeproj/project.pbxproj`

Run Script bây giờ chỉ còn:
```bash
/bin/sh "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" build
```

**Không còn export DART_DEFINES** trong script này → Tránh lỗi

### 2. Firebase Configuration

Script `Select Firebase Plist` trong Xcode sẽ tự động chọn Firebase config file:
- **Dev/Stg** → `GoogleService-Info-Dev.plist`
- **Prod** → `GoogleService-Info-Prod.plist`

### 3. App Config trong Code

File: `lib/core/config/app_config.dart`

```dart
class EnvConfig {
  static const String env = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'https://dev-api.yourdomain.com');
  static const bool enableLogging = bool.fromEnvironment('ENABLE_LOGGING', defaultValue: true);
}
```

Các biến này được truyền qua `--dart-define` khi run/build.

## 🚀 Workflow Thực tế

### Development (Hàng ngày)
```bash
make dev
```
- Hot reload hoạt động bình thường
- Debug logs được bật
- Connect đến Dev API

### Testing trước khi release
```bash
make stg
```
- Test với Staging API
- Giống môi trường production hơn

### Build để submit lên App Store
```bash
flutter build ipa \
  --dart-define=APP_ENV=prod \
  --dart-define=API_BASE_URL=https://api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=false \
  --release
```

Sau đó upload IPA file từ `build/ios/ipa/`

## 📝 Package/Bundle Identifiers

Mỗi environment có ID riêng:

**iOS**:
- **Dev**: `com.example.riverpodCleanArchitecture.dev`
- **Stg**: `com.example.riverpodCleanArchitecture.stg`
- **Prod**: `com.example.riverpodCleanArchitecture`

**Android**:
- **Dev**: `com.example.riverpod_clean_architecture.dev`
- **Stg**: `com.example.riverpod_clean_architecture.stg`
- **Prod**: `com.example.riverpod_clean_architecture`

→ Có thể cài đồng thời 3 versions trên 1 device

## ⚙️ Customization

### Thay đổi API URLs

Sửa trong các files:
- `Makefile`
- `scripts/run_dev.sh`
- `scripts/run_stg.sh`
- `scripts/run_prod.sh`

### Thêm biến config mới

1. **Thêm vào code**:
```dart
// lib/core/config/app_config.dart
static const String newVariable = String.fromEnvironment('NEW_VAR', defaultValue: 'default');
```

2. **Thêm vào các lệnh run**:
```bash
flutter run \
  --dart-define=NEW_VAR=value \
  ...
```

## 🐛 Troubleshooting

### Lỗi "DART_DEFINES not found"
→ Đừng build từ Xcode, dùng `flutter run` hoặc `flutter build` từ terminal

### Config không đúng
→ Check lại các `--dart-define` parameters khi run

### Firebase crash
→ Kiểm tra đúng Firebase plist file được copy (check script `Select Firebase Plist`)

### Pod install errors
```bash
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..
```

## 📚 Files Không Cần Quan Tâm

Các files này được Flutter tự động generate, không cần edit:
- `ios/Flutter/flutter_export_environment.sh` (generated)
- `ios/Flutter/Generated.xcconfig` (generated)
- `ios/Podfile.lock` (generated)
- `ios/.symlinks/` (generated)

## ✅ Checklist trước khi Release

- [ ] Update version trong `pubspec.yaml`
- [ ] Update API URLs cho đúng môi trường
- [ ] Test build ở cả 3 environments
- [ ] Verify Firebase config
- [ ] Test trên thiết bị thật
- [ ] Build release IPA
- [ ] Test IPA trên TestFlight (nếu có)
- [ ] Submit lên App Store

## 🎉 Tóm tắt Ưu điểm của Setup này

✅ **Không còn lỗi DART_DEFINES trong Xcode**  
✅ **Rõ ràng và dễ debug**  
✅ **Hot reload vẫn hoạt động**  
✅ **Dễ thêm environment mới**  
✅ **CI/CD friendly**  
✅ **3 apps có thể cài song song trên device**
