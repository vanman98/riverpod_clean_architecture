class AppRoutes {
  // top-level
  static const login = '/login';

  // tabs roots
  static const home = '/home';
  static const transactions = '/transactions';
  static const settings = '/settings';

  // helpers (nested)
  static String transactionDetail(String id) => '$transactions/$id';
}
