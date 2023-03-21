import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_personalization_sdk/src/flutter_personalization_sdk_method_channel.dart';

void main() {
  MethodChannelFlutterPersonalizationSdk platform = MethodChannelFlutterPersonalizationSdk();
  const MethodChannel channel = MethodChannel('flutter_personalization_sdk');

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

  });
}
