import 'dart:io';
import 'package:flutter/services.dart';

class NativeConfig {
  static const _channel = MethodChannel('app.config');

  static Future<String> get appEnv async {
    if (!Platform.isIOS)
      return const String.fromEnvironment('ENV', defaultValue: 'dev');
    return await _channel.invokeMethod<String>('appEnv') ?? 'dev';
  }

  static Future<String> get baseUrl async {
    if (!Platform.isIOS)
      return const String.fromEnvironment('API_BASE_URL', defaultValue: '');
    return await _channel.invokeMethod<String>('baseUrl') ?? '';
  }
}
