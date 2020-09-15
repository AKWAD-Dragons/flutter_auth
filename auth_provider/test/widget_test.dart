import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:auth_provider/auth_provider.dart';

void main() {
  const MethodChannel channel = MethodChannel('auth_provider');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await AuthProvider.platformVersion, '42');
  });
}
