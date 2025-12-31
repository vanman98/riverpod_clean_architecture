import 'package:flutter/widgets.dart';
import 'package:riverpod_clean_architecture/l10n/app_localizations.dart';

class Validators {
  static String? email(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (value == null || value.isEmpty) {
      return l10n.emailRequired;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return l10n.emailInvalid;
    }

    return null;
  }

  static String? password(String? value, BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }

    if (value.length < 6) {
      return l10n.passwordMinLength;
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
