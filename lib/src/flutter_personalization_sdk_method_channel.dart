import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../src/utils/Constants.dart';
import '../src/flutter_personalization_sdk_platform_interface.dart';
import 'model/WEGInline.dart';

class WEPMethodChannel
    extends WEPSdkPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel(INLINE_SDK_CHANNEL_NAME);

  @override
  Future<bool> initPersonalization() async {
    final registered = await methodChannel
        .invokeMethod<dynamic>(METHOD_NAME_INIT_PERSONALIZATION, {});
    return registered as bool;
  }

  @override
  Future<bool> registerInline(WEProperty weProperty) async {
    final registered = await methodChannel.invokeMethod<dynamic>(
        METHOD_NAME_REGISTER_INLINE, weProperty.toJSON());
    return registered as bool;
  }

  @override
  Future<bool> deregisterInline(WEProperty weProperty) async {
    final deRegistered = await methodChannel.invokeMethod<dynamic>(
        METHOD_NAME_DEREGISTER_INLINE, weProperty.toJSON());
    return deRegistered as bool;
  }

  @override
  Future<bool> autoHandleClick(bool autoHandleClick) async {
    final result = await methodChannel.invokeMethod<dynamic>(
        METHOD_NAME_AUTO_HANDLE_CLICK, autoHandleClick);
    return result as bool;
  }

  @override
  Future<bool> trackClick(
      WEProperty weProperty, Map<String, dynamic> data) async {
    var map = weProperty.toJSON();
    map["data"] = data;
    final tracked =
        await methodChannel.invokeMethod<dynamic>(METHOD_NAME_SEND_CLICK, map);
    return tracked;
  }

  @override
  Future<bool> trackImpression(
      WEProperty weProperty, Map<String, dynamic> data) async {
    var map = weProperty.toJSON();
    map["data"] = data;
    final tracked = await methodChannel.invokeMethod<dynamic>(
        METHOD_NAME_SEND_IMPRESSION, map);
    return tracked;
  }
}
