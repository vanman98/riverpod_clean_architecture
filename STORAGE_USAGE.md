# Token Storage & Auto Injection Guide

## Tổng quan
Project đã được tích hợp `flutter_secure_storage` để lưu trữ token và **tự động inject token vào mọi API request** thông qua Dio Interceptor.

## Cấu trúc

### 1. Core Layer (`lib/core/`)

#### Storage (`lib/core/storage/`)
- **`secure_storage_service.dart`**: Service abstract cho secure storage
- **`storage_keys.dart`**: Định nghĩa các keys để lưu trữ token

#### Network (`lib/core/network/`)
- **`api_client.dart`**: Dio client wrapper
- **`auth_interceptor.dart`**: 🔑 **Tự động thêm token vào mọi request**

### 2. Data Layer (`lib/features/auth/data/`)
- **`datasources.dart`**: 
  - `AuthRemoteDataSource`: Xử lý API login/logout
  - `AuthLocalDataSource`: Lưu/đọc token từ secure storage

### 3. Domain Layer (`lib/features/auth/domain/`)
- **`repository.dart`**: Interface với methods `getToken()`, `getRefreshToken()`
- **`usecases.dart`**: 
  - `GetTokenUseCase`: Lấy access token
  - `GetRefreshTokenUseCase`: Lấy refresh token

---

## 🚀 Cách sử dụng

### 1. Login (Tự động lưu token)
```dart
// Token được lưu tự động vào secure storage
await ref.read(authNotifierProvider.notifier).login(email, password);

// Từ giờ MỌI API call đều tự động có token trong header!
```

### 2. Gọi API - Token tự động được thêm ✨
```dart
// KHÔNG CẦN làm gì thêm! Token tự động inject vào header
final response = await client.get('/profile');
final response = await client.post('/update-profile', data: {...});

// Interceptor tự động thêm: Authorization: Bearer <token>
```

### 3. Logout (Tự động xóa token)
```dart
// Token được xóa khỏi storage
await ref.read(authNotifierProvider.notifier).logout();

// Các API call tiếp theo sẽ KHÔNG có token
```

### 4. Manual: Lấy token nếu cần
```dart
// Trong trường hợp đặc biệt cần token thủ công
final repository = ref.read(authRepositoryProvider);
final token = await repository.getToken();

if (token != null) {
  // Làm gì đó với token
}
```

---

## 🔄 Flow hoạt động chi tiết

### Flow 1: Login → Lưu token
```
User login
    ↓
AuthNotifier.login()
    ↓
LoginUseCase
    ↓
AuthRepository.login()
    ↓
[Remote] Gọi API /login → Nhận token
    ↓
[Local] AuthLocalDataSource.saveToken() → Lưu vào SecureStorage
    ↓
Return UserEntity
```

### Flow 2: API Call → Auto inject token
```
Bất kỳ API call nào
    ↓
Dio Request
    ↓
AuthInterceptor.onRequest()
    ↓
Đọc token từ SecureStorage
    ↓
Nếu có token → Thêm vào header: "Authorization: Bearer <token>"
    ↓
Gửi request với token
```

### Flow 3: Token hết hạn (401)
```
API trả về 401 Unauthorized
    ↓
AuthInterceptor.onError()
    ↓
Có thể implement:
  - Auto refresh token
  - Redirect to login
  - Show error
```

---

## 📝 Example: Tạo API cần token

### Ví dụ 1: Get User Profile
```dart
// lib/features/profile/data/datasources.dart
class ProfileRemoteDataSource {
  final ApiClient client;
  
  ProfileRemoteDataSource(this.client);
  
  Future<ProfileModel> getProfile() async {
    // KHÔNG CẦN thêm token thủ công!
    // AuthInterceptor tự động inject token
    final json = await client.get('/profile');
    return ProfileModel.fromJson(json);
  }
}
```

### Ví dụ 2: Update User Info
```dart
Future<void> updateProfile(Map<String, dynamic> data) async {
  // Token tự động được thêm vào request
  await client.post('/profile/update', data: data);
}
```

### Ví dụ 3: Upload File with Token
```dart
Future<void> uploadAvatar(File file) async {
  final formData = FormData.fromMap({
    'avatar': await MultipartFile.fromFile(file.path),
  });
  
  // Token vẫn tự động inject vào multipart request
  await client.rawDio.post('/upload-avatar', data: formData);
}
```

---

## 🔐 AuthInterceptor hoạt động như thế nào?

```dart
class AuthInterceptor extends Interceptor {
  final SecureStorageService storageService;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 1. Đọc token từ secure storage
    final token = await storageService.read(StorageKeys.accessToken);

    // 2. Nếu có token → Thêm vào header
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // 3. Tiếp tục request
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Xử lý lỗi 401 (Token hết hạn)
    if (err.response?.statusCode == 401) {
      // TODO: Implement refresh token logic
      // hoặc redirect về login
    }
    
    handler.next(err);
  }
}
```

---

## ⚙️ Cấu hình trong DI

```dart
// lib/core/di/app_providers.dart
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final storageService = ref.watch(secureStorageServiceProvider);

  return ApiClient(
    baseUrl: config.apiBaseUrl,
    enableLogging: config.enableLogging,
    storageService: storageService, // ← Inject storage để interceptor dùng
  );
});
```

---

## 🎯 Lợi ích của approach này

✅ **Tự động hoàn toàn**: Không cần thêm token thủ công ở mỗi API call  
✅ **Centralized**: Logic token ở 1 chỗ (AuthInterceptor)  
✅ **Clean Code**: Repository/DataSource không lo về token  
✅ **Dễ maintain**: Đổi format token (Bearer, JWT, etc.) chỉ sửa 1 chỗ  
✅ **Secure**: Token lưu trong encrypted storage  
✅ **Testable**: Mock interceptor dễ dàng khi test  

---

## 🔧 Advanced: Thêm Refresh Token Logic

Nếu cần tự động refresh token khi hết hạn:

```dart
@override
void onError(DioException err, ErrorInterceptorHandler handler) async {
  if (err.response?.statusCode == 401) {
    // 1. Lấy refresh token
    final refreshToken = await storageService.read(StorageKeys.refreshToken);
    
    if (refreshToken != null) {
      try {
        // 2. Gọi API refresh token
        final newToken = await _refreshToken(refreshToken);
        
        // 3. Lưu token mới
        await storageService.write(StorageKeys.accessToken, newToken);
        
        // 4. Retry request cũ với token mới
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer $newToken';
        final response = await _dio.fetch(options);
        return handler.resolve(response);
      } catch (e) {
        // Refresh token failed → Redirect to login
      }
    }
  }
  
  handler.next(err);
}
```

---

## 📌 Lưu ý quan trọng

1. **Login API không cần token**: AuthInterceptor chỉ thêm token nếu có
2. **Public APIs**: Vẫn hoạt động bình thường (không có token trong header)
3. **Token format**: Mặc định dùng `Bearer <token>`, có thể custom
4. **Error handling**: Implement logic 401 phù hợp với backend

---

## 🆚 So sánh: Trước vs Sau

### ❌ Trước (Manual - Dễ quên, lặp code)
```dart
Future<ProfileModel> getProfile() async {
  // Phải lấy token thủ công mỗi lần
  final token = await storage.read('token');
  final json = await client.get(
    '/profile',
    headers: {'Authorization': 'Bearer $token'}, // Lặp lại mỗi nơi
  );
  return ProfileModel.fromJson(json);
}
```

### ✅ Sau (Auto - Không cần lo)
```dart
Future<ProfileModel> getProfile() async {
  // Token tự động inject!
  final json = await client.get('/profile');
  return ProfileModel.fromJson(json);
}
```
