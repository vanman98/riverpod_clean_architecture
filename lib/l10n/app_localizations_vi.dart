// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Finance Riverpod Clean Arch';

  @override
  String get login => 'Đăng nhập';

  @override
  String get loginTitle => 'Đăng nhập (Finance Demo)';

  @override
  String get loginHeader => 'Đăng nhập';

  @override
  String get demoCredentials => 'Thông tin demo';

  @override
  String get demoCredentialsInfo => 'Email: demo@example.com\nMật khẩu: 123456';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Nhập email của bạn';

  @override
  String get password => 'Mật khẩu';

  @override
  String get passwordHint => 'Nhập mật khẩu của bạn';

  @override
  String get emailRequired => 'Email không được để trống';

  @override
  String get emailInvalid => 'Email không đúng định dạng';

  @override
  String get passwordRequired => 'Mật khẩu không được để trống';

  @override
  String get passwordMinLength => 'Mật khẩu phải có ít nhất 6 ký tự';

  @override
  String get errorServerBusy => 'Server đang gặp sự cố. Vui lòng thử lại sau.';

  @override
  String get errorServerGeneric => 'Đã có lỗi từ server. Vui lòng thử lại.';

  @override
  String get errorServerDefault => 'Đã có lỗi xảy ra';

  @override
  String get errorNetwork =>
      'Không có kết nối internet. Vui lòng kiểm tra và thử lại.';

  @override
  String get errorNetworkTimeout => 'Kết nối timeout, vui lòng thử lại';

  @override
  String get errorNetworkDisconnected => 'Không có kết nối internet';

  @override
  String get errorUnauthorized =>
      'Email hoặc mật khẩu không đúng. Vui lòng thử lại.';

  @override
  String get errorUnauthorizedAccess => 'Bạn không có quyền truy cập';

  @override
  String get errorValidation => 'Dữ liệu không hợp lệ.';

  @override
  String get errorNotFound => 'Tài khoản không tồn tại.';

  @override
  String get errorCache => 'Lỗi lưu trữ dữ liệu. Vui lòng thử lại.';

  @override
  String get errorUnexpected => 'Đã có lỗi xảy ra. Vui lòng thử lại.';

  @override
  String get errorRequestCancelled => 'Request đã bị hủy';

  @override
  String get errorUnknown => 'Lỗi không xác định';

  @override
  String get close => 'Đóng';

  @override
  String get retry => 'Thử lại';

  @override
  String get cancel => 'Hủy';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get save => 'Lưu';

  @override
  String get delete => 'Xóa';

  @override
  String get edit => 'Sửa';

  @override
  String get done => 'Hoàn thành';

  @override
  String get loading => 'Đang tải...';

  @override
  String get noData => 'Không có dữ liệu';

  @override
  String get refresh => 'Làm mới';
}
