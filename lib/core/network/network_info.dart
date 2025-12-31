import 'dart:async';
import 'dart:io';

abstract class NetworkInfo {
  Future<bool> get isConnected;
  Stream<bool> get onConnectivityChanged;
}

class NetworkInfoImpl implements NetworkInfo {
  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();

  bool _lastConnectionStatus = true;
  Timer? _checkTimer;

  NetworkInfoImpl() {
    _startPeriodicCheck();
    _checkConnection();
  }

  void _startPeriodicCheck() {
    _checkTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _checkConnection(),
    );
  }

  Future<void> _checkConnection() async {
    final connected = await isConnected;
    if (connected != _lastConnectionStatus) {
      _lastConnectionStatus = connected;
      _connectivityController.add(connected);
    }
  }

  @override
  Future<bool> get isConnected async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    } catch (_) {
      return false;
    }
  }

  @override
  Stream<bool> get onConnectivityChanged => _connectivityController.stream;

  void dispose() {
    _checkTimer?.cancel();
    _connectivityController.close();
  }
}
