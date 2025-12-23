import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/login_page.dart';
// import '../features/transactions/presentation/transactions_page.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      // GoRoute(
      //   path: '/transactions',
      //   name: 'transactions',
      //   builder: (context, state) => const TransactionsPage(),
      // ),
    ],
  );
});
