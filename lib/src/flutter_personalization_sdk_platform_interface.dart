import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../src/flutter_personalization_sdk_method_channel.dart';
import 'model/WEGInline.dart';

/// This Class is a bridge between flutter and native.
abstract class WEPSdkPlatform extends PlatformInterface {
  WEPSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static WEPSdkPlatform _instance =
      WEPMethodChannel();

  static WEPSdkPlatform get instance => _instance;

  static set instance(WEPSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> initPersonalization() {
    throw UnimplementedError('initInline has not been implemented');
  }

  Future<bool> registerInline(WEProperty weProperty) {
    throw UnimplementedError(
        'registerPersonalization has not been implemented');
  }

  Future<bool> deregisterInline(WEProperty weProperty) {
    throw UnimplementedError(
        'deregisterPersonalization has not been implemented');
  }

  Future<bool> autoHandleClick(bool autoHandleClick) {
    throw UnimplementedError("auto handle click has not been implemented");
  }

  Future<bool> trackClick(WEProperty weProperty, Map<String, dynamic> data) {
    throw UnimplementedError("trackClick has not been implemented");
  }

  Future<bool> trackImpression(WEProperty weProperty, Map<String, dynamic> data) {
    throw UnimplementedError("trackImpression has not been implemented");
  }
}
