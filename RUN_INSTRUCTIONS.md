# Hướng dẫn chạy ứng dụng với các môi trường khác nhau

Để tránh lỗi với DART_DEFINES trong Xcode, bạn có thể sử dụng `flutter run` trực tiếp từ terminal với các biến config.

## Phương pháp 1: Sử dụng Makefile (Khuyến nghị)

### Chạy môi trường DEV
```bash
make dev
```

### Chạy môi trường STG
```bash
make stg
```

### Chạy môi trường PROD
```bash
make prod
```

### Clean build
```bash
make clean
```

### Xem tất cả lệnh
```bash
make help
```

## Phương pháp 2: Sử dụng Shell Scripts

### Chạy môi trường DEV
```bash
./scripts/run_dev.sh
```

### Chạy môi trường STG
```bash
./scripts/run_stg.sh
```

### Chạy môi trường PROD
```bash
./scripts/run_prod.sh
```

### Truyền thêm tham số
Bạn có thể truyền thêm các tham số Flutter vào scripts:
```bash
./scripts/run_dev.sh -d <device-id>
./scripts/run_dev.sh --release
```

## Phương pháp 3: Chạy trực tiếp từ Terminal

### DEV
```bash
flutter run \
  --dart-define=APP_ENV=dev \
  --dart-define=API_BASE_URL=https://dev-api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=true
```

### STG
```bash
flutter run \
  --dart-define=APP_ENV=stg \
  --dart-define=API_BASE_URL=https://stg-api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=true
```

### PROD
```bash
flutter run \
  --dart-define=APP_ENV=prod \
  --dart-define=API_BASE_URL=https://api.yourdomain.com \
  --dart-define=ENABLE_LOGGING=false
```

## Phương pháp 4: Chạy từ VSCode/IDE

Trong VSCode, bạn đã có sẵn các launch configurations tại `.vscode/launch.json`:
- **Dev**: Chạy môi trường dev
- **Stg**: Chạy môi trường stg  
- **Prod**: Chạy môi trường prod

Chỉ cần chọn configuration và nhấn F5 để chạy.

## Lưu ý quan trọng

1. **Cập nhật API URLs**: Nhớ thay đổi các URL API trong scripts/Makefile cho phù hợp với backend của bạn:
   - `https://dev-api.yourdomain.com`
   - `https://stg-api.yourdomain.com`
   - `https://api.yourdomain.com`

2. **Chạy trên iOS Simulator**:
   ```bash
   make dev  # Sẽ tự động chạy trên simulator đang mở
   ```

3. **Chạy trên thiết bị iOS thật**:
   ```bash
   flutter devices  # Xem danh sách devices
   flutter run -d <device-id> --dart-define=APP_ENV=dev ...
   ```

4. **Build release**:
   ```bash
   flutter build ios \
     --dart-define=APP_ENV=prod \
     --dart-define=API_BASE_URL=https://api.yourdomain.com \
     --dart-define=ENABLE_LOGGING=false
   ```

## Lợi ích của phương pháp này

✅ **Không cần config DART_DEFINES trong Xcode** - Tránh lỗi build script
✅ **Dễ debug** - Xem rõ các biến environment đang sử dụng
✅ **Linh hoạt** - Dễ dàng thay đổi giá trị mà không cần sửa Xcode project
✅ **Hot reload/restart** - Vẫn hoạt động bình thường
✅ **Cross-platform** - Cùng cách dùng cho cả iOS và Android
