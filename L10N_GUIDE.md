# 🌍 Internationalization (l10n) Guide

## ✅ Implementation Complete

The project now supports **3 languages**:
- 🇺🇸 English (en)
- 🇯🇵 Japanese (ja)
- 🇻🇳 Vietnamese (vi)

---

## 📁 Project Structure

```
lib/
├── l10n/
│   ├── app_en.arb          # English translations
│   ├── app_ja.arb          # Japanese translations
│   ├── app_vi.arb          # Vietnamese translations
│   ├── app_localizations.dart (generated)
│   ├── app_localizations_en.dart (generated)
│   ├── app_localizations_ja.dart (generated)
│   └── app_localizations_vi.dart (generated)
l10n.yaml                   # Configuration
```

---

## 🎯 How to Use l10n

### **1. In Widgets**

```dart
import 'package:riverpod_clean_architecture/l10n/app_localizations.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: Column(
        children: [
          Text(l10n.loginHeader),
          ElevatedButton(
            onPressed: () {},
            child: Text(l10n.login),
          ),
        ],
      ),
    );
  }
}
```

### **2. In Validators**

```dart
// validators.dart
static String? email(String? value, BuildContext context) {
  final l10n = AppLocalizations.of(context);
  
  if (value == null || value.isEmpty) {
    return l10n.emailRequired;
  }
  
  if (!emailRegex.hasMatch(value)) {
    return l10n.emailInvalid;
  }
  
  return null;
}

// Usage in form
CustomTextField(
  validator: (value) => Validators.email(value, context),
)
```

### **3. In Failure Messages**

```dart
// failure.dart extension
String localizedMessage(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return when(
    network: (message) => l10n.errorNetwork,
    unauthorized: (message) => l10n.errorUnauthorized,
    // ...
  );
}

// Usage in UI
ref.listen(authProvider, (prev, next) {
  if (next.error != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(next.error!)),
    );
  }
});
```

---

## 🔄 How to Switch Languages

### **Option 1: In Settings Page**

```dart
class SettingsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);
    
    return ListTile(
      title: Text('Language'),
      subtitle: Text(_getLanguageName(currentLocale)),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () => _showLanguageDialog(context, ref),
    );
  }
  
  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, ref, 'en', '🇺🇸 English'),
            _buildLanguageOption(context, ref, 'ja', '🇯🇵 日本語'),
            _buildLanguageOption(context, ref, 'vi', '🇻🇳 Tiếng Việt'),
          ],
        ),
      ),
    );
  }
  
  Widget _buildLanguageOption(
    BuildContext context, 
    WidgetRef ref, 
    String languageCode, 
    String label
  ) {
    return ListTile(
      title: Text(label),
      onTap: () {
        ref.read(localeProvider.notifier).setLocale(Locale(languageCode));
        Navigator.pop(context);
      },
    );
  }
}
```

### **Option 2: Quick Switch Button**

```dart
IconButton(
  icon: Icon(Icons.language),
  onPressed: () {
    final currentLocale = ref.read(localeProvider);
    
    // Cycle through languages
    final nextLocale = switch (currentLocale?.languageCode) {
      'en' => const Locale('ja'),
      'ja' => const Locale('vi'),
      _ => const Locale('en'),
    };
    
    ref.read(localeProvider.notifier).setLocale(nextLocale);
  },
)
```

### **Option 3: Reset to System Locale**

```dart
ref.read(localeProvider.notifier).clearLocale();
// null = use device's system locale
```

---

## ➕ How to Add New Strings

### **Step 1: Add to ARB files**

**app_en.arb:**
```json
{
  "welcomeMessage": "Welcome to our app!",
  "@welcomeMessage": {
    "description": "Welcome message shown on home page"
  }
}
```

**app_ja.arb:**
```json
{
  "welcomeMessage": "アプリへようこそ！"
}
```

**app_vi.arb:**
```json
{
  "welcomeMessage": "Chào mừng đến với ứng dụng!"
}
```

### **Step 2: Run code generation**

```bash
flutter gen-l10n
# or just
flutter pub get
```

### **Step 3: Use in code**

```dart
final l10n = AppLocalizations.of(context);
Text(l10n.welcomeMessage)
```

---

## 📝 Adding Strings with Parameters

### **ARB files:**

```json
{
  "greeting": "Hello, {name}!",
  "@greeting": {
    "description": "Greeting message with user name",
    "placeholders": {
      "name": {
        "type": "String"
      }
    }
  },
  
  "itemCount": "{count, plural, =0{No items} =1{1 item} other{{count} items}}",
  "@itemCount": {
    "description": "Number of items",
    "placeholders": {
      "count": {
        "type": "int"
      }
    }
  }
}
```

### **Usage:**

```dart
Text(l10n.greeting('John'))
// English: "Hello, John!"
// Japanese: "こんにちは、Johnさん！"

Text(l10n.itemCount(5))
// English: "5 items"
// Japanese: "5個のアイテム"
```

---

## 🎨 Current Translations

### **App Common**
- `appTitle`: App title

### **Authentication**
- `login`: Login button
- `loginTitle`: Login page title
- `loginHeader`: Login header text
- `email`: Email label
- `emailHint`: Email input hint
- `emailRequired`: Email required error
- `emailInvalid`: Email invalid error
- `password`: Password label
- `passwordHint`: Password input hint
- `passwordRequired`: Password required error
- `passwordMinLength`: Password length error
- `demoCredentials`: Demo credentials label
- `demoCredentialsInfo`: Demo credentials text

### **Error Messages**
- `errorServerBusy`: Server 5xx error
- `errorServerGeneric`: Generic server error
- `errorServerDefault`: Default error
- `errorNetwork`: No internet connection
- `errorNetworkTimeout`: Connection timeout
- `errorNetworkDisconnected`: No connection
- `errorUnauthorized`: Wrong credentials
- `errorUnauthorizedAccess`: No permission
- `errorValidation`: Invalid data
- `errorNotFound`: Resource not found
- `errorCache`: Cache error
- `errorUnexpected`: Unexpected error
- `errorRequestCancelled`: Request cancelled
- `errorUnknown`: Unknown error

### **Common Actions**
- `close`: Close button
- `retry`: Retry button
- `cancel`: Cancel button
- `confirm`: Confirm button
- `save`: Save button
- `delete`: Delete button
- `edit`: Edit button
- `done`: Done button
- `loading`: Loading text
- `noData`: No data text
- `refresh`: Refresh button

---

## 🧪 Testing Different Languages

### **Method 1: Change device language**
1. Go to device Settings
2. Change language to English/Japanese/Vietnamese
3. App will automatically use that language

### **Method 2: Force specific locale (testing)**

```dart
// In app.dart for testing only
return MaterialApp.router(
  locale: const Locale('ja'), // Force Japanese
  // ... rest of config
);
```

### **Method 3: Use locale provider**

```dart
// In any page
ref.read(localeProvider.notifier).setLocale(const Locale('ja'));
```

---

## 📊 Language Support Overview

| Language | Code | Status | Translator |
|----------|------|--------|-----------|
| English | en | ✅ Complete | Native |
| Japanese | ja | ✅ Complete | Professional |
| Vietnamese | vi | ✅ Complete | Native |

---

## 🚀 Adding a New Language

### **Step 1: Create ARB file**

```bash
# Create new file
touch lib/l10n/app_fr.arb  # French example
```

### **Step 2: Add locale to ARB**

```json
{
  "@@locale": "fr",
  "appTitle": "Finance Riverpod Clean Arch",
  "login": "Connexion",
  ...
}
```

### **Step 3: Update supportedLocales in app.dart**

```dart
supportedLocales: const [
  Locale('en'),
  Locale('ja'),
  Locale('vi'),
  Locale('fr'), // ← Add new locale
],
```

### **Step 4: Run generation**

```bash
flutter pub get
```

---

## 💡 Best Practices

### **1. Always use l10n for user-facing text**

❌ **BAD:**
```dart
Text('Login')
```

✅ **GOOD:**
```dart
Text(l10n.login)
```

### **2. Keep ARB keys descriptive**

❌ **BAD:**
```json
{
  "btn1": "Submit",
  "txt2": "Error"
}
```

✅ **GOOD:**
```json
{
  "submitButton": "Submit",
  "errorMessage": "Error"
}
```

### **3. Add descriptions to ARB entries**

```json
{
  "loginButton": "Login",
  "@loginButton": {
    "description": "Button text for logging into the application"
  }
}
```

### **4. Group related strings**

```json
{
  "authLogin": "Login",
  "authLogout": "Logout",
  "authRegister": "Register",
  
  "errorNetwork": "No internet",
  "errorServer": "Server error"
}
```

### **5. Use placeholders for dynamic content**

```json
{
  "welcomeUser": "Welcome, {username}!",
  "@welcomeUser": {
    "placeholders": {
      "username": {"type": "String"}
    }
  }
}
```

---

## 🔧 Troubleshooting

### **Strings not updating?**

```bash
# Clean and regenerate
flutter clean
flutter pub get
```

### **"AppLocalizations not found" error?**

1. Check `l10n.yaml` exists
2. Check `generate: true` in `pubspec.yaml`
3. Run `flutter pub get`

### **Locale not switching?**

```dart
// Make sure MaterialApp watches localeProvider
final locale = ref.watch(localeProvider);

return MaterialApp.router(
  locale: locale, // ← Must be here
  localizationsDelegates: ...,
  supportedLocales: ...,
);
```

---

## 📚 Resources

- [Flutter Internationalization](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
- [ARB File Format](https://github.com/google/app-resource-bundle/wiki/ApplicationResourceBundleSpecification)
- [Intl Package](https://pub.dev/packages/intl)

---

## ✅ Summary

**What's Implemented:**
- ✅ gen_l10n code generation
- ✅ 3 languages (English, Japanese, Vietnamese)
- ✅ All error messages localized
- ✅ All UI strings localized
- ✅ Validators localized
- ✅ Language switching support
- ✅ System locale detection

**How to Use:**
1. Get l10n: `final l10n = AppLocalizations.of(context);`
2. Use strings: `Text(l10n.login)`
3. Switch language: `ref.read(localeProvider.notifier).setLocale(Locale('ja'))`

**How to Add Strings:**
1. Add to all 3 ARB files (en, ja, vi)
2. Run `flutter pub get`
3. Use `l10n.yourNewString`

**Your app is now fully internationalized! 🎉**
