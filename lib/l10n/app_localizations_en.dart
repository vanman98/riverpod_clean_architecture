// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Finance Riverpod Clean Arch';

  @override
  String get login => 'Login';

  @override
  String get loginTitle => 'Login (Finance Demo)';

  @override
  String get loginHeader => 'Sign In';

  @override
  String get demoCredentials => 'Demo credentials';

  @override
  String get demoCredentialsInfo => 'Email: demo@example.com\nPassword: 123456';

  @override
  String get email => 'Email';

  @override
  String get emailHint => 'Enter your email';

  @override
  String get password => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Invalid email format';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get errorServerBusy =>
      'Server is experiencing issues. Please try again later.';

  @override
  String get errorServerGeneric => 'Server error occurred. Please try again.';

  @override
  String get errorServerDefault => 'An error occurred';

  @override
  String get errorNetwork =>
      'No internet connection. Please check and try again.';

  @override
  String get errorNetworkTimeout => 'Connection timeout, please try again';

  @override
  String get errorNetworkDisconnected => 'No internet connection';

  @override
  String get errorUnauthorized =>
      'Email or password is incorrect. Please try again.';

  @override
  String get errorUnauthorizedAccess => 'You do not have access permission';

  @override
  String get errorValidation => 'Invalid data.';

  @override
  String get errorNotFound => 'Account does not exist.';

  @override
  String get errorCache => 'Data storage error. Please try again.';

  @override
  String get errorUnexpected => 'An error occurred. Please try again.';

  @override
  String get errorRequestCancelled => 'Request was cancelled';

  @override
  String get errorUnknown => 'Unknown error';

  @override
  String get close => 'Close';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get done => 'Done';

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No data';

  @override
  String get refresh => 'Refresh';
}
