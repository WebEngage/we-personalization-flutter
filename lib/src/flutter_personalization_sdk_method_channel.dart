import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../src/flutter_personalization_sdk_platform_interface.dart';
import '../src/utils/we_constant.dart';
import '../src/utils/we_logger.dart';
import 'model/weg_inline.dart';

class WEPMethodChannel extends WEPSdkPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel(INLINE_SDK_CHANNEL_NAME);

  @override
  Future<bool> initPersonalization() async {
    WELogger.v("WEPMethodChannel init Personalization");
    final registered = await methodChannel
        .invokeMethod<dynamic>(METHOD_NAME_INIT_PERSONALIZATION, {});
    return registered as bool;
  }

  @override
  Future<bool> registerInline(WEProperty weProperty) async {
    WELogger.v(
        "WEPMethodChannel register custom property with data ${weProperty.toJSON()}");
    final registered = await methodChannel.invokeMethod<dynamic>(
        METHOD_NAME_REGISTER_INLINE, weProperty.toJSON());
    return registered as bool;
  }

  @override
  Future<bool> deregisterInline(WEProperty weProperty) async {
    WELogger.v(
        "WEPMethodChannel deregister custom property with data ${weProperty.toJSON()}");
    final deRegistered = await methodChannel.invokeMethod<dynamic>(
        METHOD_NAME_DEREGISTER_INLINE, weProperty.toJSON());
    return deRegistered as bool;
  }

  @override
  Future<bool> trackClick(
      WEProperty weProperty, Map<String, dynamic> data) async {
    var map = weProperty.toJSON();
    WELogger.v(
        "WEPMethodChannel trackClick for custom property with data ${weProperty.toJSON()} attributes : $data");
    map["data"] = data;
    final tracked =
        await methodChannel.invokeMethod<dynamic>(METHOD_NAME_SEND_CLICK, map);
    return tracked;
  }

  @override
  Future<bool> trackImpression(
      WEProperty weProperty, Map<String, dynamic> data) async {
    WELogger.v(
        "WEPMethodChannel trackImpression for custom property with data ${weProperty.toJSON()} attributes : $data");
    var map = weProperty.toJSON();
    map["data"] = data;
    final tracked = await methodChannel.invokeMethod<dynamic>(
        METHOD_NAME_SEND_IMPRESSION, map);
    return tracked;
  }
}
