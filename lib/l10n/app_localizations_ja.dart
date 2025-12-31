// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'ファイナンス Riverpod Clean Arch';

  @override
  String get login => 'ログイン';

  @override
  String get loginTitle => 'ログイン (Finance Demo)';

  @override
  String get loginHeader => 'サインイン';

  @override
  String get demoCredentials => 'デモ認証情報';

  @override
  String get demoCredentialsInfo => 'メール: demo@example.com\nパスワード: 123456';

  @override
  String get email => 'メール';

  @override
  String get emailHint => 'メールアドレスを入力してください';

  @override
  String get password => 'パスワード';

  @override
  String get passwordHint => 'パスワードを入力してください';

  @override
  String get emailRequired => 'メールは必須です';

  @override
  String get emailInvalid => 'メール形式が無効です';

  @override
  String get passwordRequired => 'パスワードは必須です';

  @override
  String get passwordMinLength => 'パスワードは6文字以上である必要があります';

  @override
  String get errorServerBusy => 'サーバーに問題が発生しています。後でもう一度お試しください。';

  @override
  String get errorServerGeneric => 'サーバーエラーが発生しました。もう一度お試しください。';

  @override
  String get errorServerDefault => 'エラーが発生しました';

  @override
  String get errorNetwork => 'インターネット接続がありません。確認してもう一度お試しください。';

  @override
  String get errorNetworkTimeout => '接続タイムアウト、もう一度お試しください';

  @override
  String get errorNetworkDisconnected => 'インターネット接続がありません';

  @override
  String get errorUnauthorized => 'メールまたはパスワードが正しくありません。もう一度お試しください。';

  @override
  String get errorUnauthorizedAccess => 'アクセス権限がありません';

  @override
  String get errorValidation => '無効なデータです。';

  @override
  String get errorNotFound => 'アカウントが存在しません。';

  @override
  String get errorCache => 'データストレージエラー。もう一度お試しください。';

  @override
  String get errorUnexpected => 'エラーが発生しました。もう一度お試しください。';

  @override
  String get errorRequestCancelled => 'リクエストがキャンセルされました';

  @override
  String get errorUnknown => '不明なエラー';

  @override
  String get close => '閉じる';

  @override
  String get retry => '再試行';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get done => '完了';

  @override
  String get loading => '読み込み中...';

  @override
  String get noData => 'データなし';

  @override
  String get refresh => '更新';
}
