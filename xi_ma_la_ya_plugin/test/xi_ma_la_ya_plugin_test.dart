import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xi_ma_la_ya_plugin/xi_ma_la_ya_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('xi_ma_la_ya_plugin');

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
    expect(await XiMaLaYaPlugin.platformVersion, '42');
  });
}
