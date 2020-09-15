import 'dart:async';

import 'package:flutter/services.dart';

class AuthProvider {
  static const MethodChannel _channel = const MethodChannel('auth_provider');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
