import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:anyline_plugin/anyline_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('anyline_plugin');

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
    expect(await AnylinePlugin.platformVersion, '42');
  });
}
