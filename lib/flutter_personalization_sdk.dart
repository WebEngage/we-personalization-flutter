
import 'flutter_personalization_sdk_platform_interface.dart';

class FlutterPersonalizationSdk {
  Future<String?> getPlatformVersion() {
    return FlutterPersonalizationSdkPlatform.instance.getPlatformVersion();
  }
}
