class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email không được để trống';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Email không đúng định dạng';
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu không được để trống';
    }

    if (value.length < 6) {
      return 'Mật khẩu phải có ít nhất 6 ký tự';
    }

    return null;
  }

  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Trường này'} không được để trống';
    }
    return null;
  }

  static String? minLength(String? value, int minLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'Trường này'} không được để trống';
    }

    if (value.length < minLength) {
      return '${fieldName ?? 'Trường này'} phải có ít nhất $minLength ký tự';
    }

    return null;
  }

  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Số điện thoại không được để trống';
    }

    final phoneRegex = RegExp(r'^[0-9]{10,11}$');

    if (!phoneRegex.hasMatch(value)) {
      return 'Số điện thoại không đúng định dạng';
    }

    return null;
  }
}
