import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_personalization_sdk/src/flutter_personalization_sdk.dart';
import 'package:flutter_personalization_sdk/flutter_personalization_sdk_platform_interface.dart';
import 'package:flutter_personalization_sdk/src/flutter_personalization_sdk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterPersonalizationSdkPlatform
    with MockPlatformInterfaceMixin
    implements FlutterPersonalizationSdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterPersonalizationSdkPlatform initialPlatform = FlutterPersonalizationSdkPlatform.instance;

  test('$MethodChannelFlutterPersonalizationSdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterPersonalizationSdk>());
  });

  test('getPlatformVersion', () async {
    FlutterPersonalizationSdk flutterPersonalizationSdkPlugin = FlutterPersonalizationSdk();
    MockFlutterPersonalizationSdkPlatform fakePlatform = MockFlutterPersonalizationSdkPlatform();
    FlutterPersonalizationSdkPlatform.instance = fakePlatform;

    expect(await flutterPersonalizationSdkPlugin.getPlatformVersion(), '42');
  });
}
