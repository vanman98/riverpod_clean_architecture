import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:riverpod_clean_architecture/app/router/router_provider.dart';
import 'package:riverpod_clean_architecture/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Locale Notifier for language switching
class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() => null; // null = use system locale

  void setLocale(Locale locale) => state = locale;
  void clearLocale() => state = null;
}

final localeProvider = NotifierProvider<LocaleNotifier, Locale?>(
  () => LocaleNotifier(),
);

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    final locale = ref.watch(localeProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Finance Riverpod Clean Arch',
          debugShowCheckedModeBanner: false,

          // Localization support
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'), // English
            Locale('ja'), // Japanese
            Locale('vi'), // Vietnamese
          ],
          locale: locale,

          theme: ThemeData(
            useMaterial3: true,
            colorSchemeSeed: Colors.green,
          ),
          routerConfig: router,
        );
      },
    );
  }
}
