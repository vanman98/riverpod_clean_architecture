import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_clean_architecture/app/router/app_routes.dart';
import 'package:riverpod_clean_architecture/features/auth/presentation/login_page.dart';
import 'package:riverpod_clean_architecture/features/auth/presentation/state/auth_state.dart';
import 'package:riverpod_clean_architecture/features/home/home_page.dart';
import '../../features/auth/presentation/auth_notifier.dart';
import '../shell/app_shell.dart';
import '../../features/transactions/transactions_page.dart';
import '../../features/transactions/transaction_detail_page.dart';
import '../../features/settings/settings_page.dart';

final _rootKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _homeKey = GlobalKey<NavigatorState>(debugLabel: 'homeTab');
final _txKey = GlobalKey<NavigatorState>(debugLabel: 'txTab');
final _settingsKey = GlobalKey<NavigatorState>(debugLabel: 'settingsTab');

/// ✅ Bridge: Riverpod state -> GoRouter refresh
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(this.ref) {
    // nghe auth state, hễ đổi -> router chạy lại redirect
    ref.listen<AuthState>(authProvider, (_, __) => notifyListeners());
  }
  final Ref ref;
}

final _routerRefreshProvider = Provider<RouterRefreshNotifier>((ref) {
  final n = RouterRefreshNotifier(ref);
  ref.onDispose(n.dispose);
  return n;
});

final goRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(_routerRefreshProvider);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: AppRoutes.home,
    refreshListenable: refresh,
    redirect: (context, state) {
      final loggedIn = ref.read(authProvider).isLoggedIn;
      final goingToLogin = state.matchedLocation == AppRoutes.login;

      // Nếu chưa login mà vào bất kỳ màn nào ngoài /login
      if (!loggedIn && !goingToLogin) {
        final from = state.uri.toString(); // lưu lại URL đích
        return '${AppRoutes.login}?from=${Uri.encodeComponent(from)}';
      }

      // Nếu đã login mà lại vào /login => đưa về nơi cần về
      if (loggedIn && goingToLogin) {
        final from = state.uri.queryParameters['from'];
        if (from != null && from.isNotEmpty) {
          return Uri.decodeComponent(from);
        }
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      // ----- Separate route (outside tabs)
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),

      // ----- Bottom tabs shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          // Home tab
          StatefulShellBranch(
            navigatorKey: _homeKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),

          // Transactions tab (nested)
          StatefulShellBranch(
            navigatorKey: _txKey,
            routes: [
              GoRoute(
                path: AppRoutes.transactions,
                builder: (context, state) => const TransactionsPage(),
                routes: [
                  GoRoute(
                    path: ':id', // => /transactions/:id
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return TransactionDetailPage(id: id);
                    },
                  ),
                ],
              ),
            ],
          ),

          // Settings tab
          StatefulShellBranch(
            navigatorKey: _settingsKey,
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (context, state) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
