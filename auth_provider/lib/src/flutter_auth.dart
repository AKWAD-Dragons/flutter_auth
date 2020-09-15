import 'dart:async';

import 'package:flutter/services.dart';

class FlutterAuth {
  static const MethodChannel _channel =
      const MethodChannel('flutter_auth');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
