import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../src/utils/Constants.dart';
import '../src/flutter_personalization_sdk_platform_interface.dart';
import 'model/WEGInline.dart';

class MethodChannelFlutterPersonalizationSdk extends FlutterPersonalizationSdkPlatform {

  @visibleForTesting
  final methodChannel = const MethodChannel(INLINE_SDK_CHANNEL_NAME);

  @override
  Future<bool> initPersonalization() async {
    final registered = await methodChannel.invokeMethod<dynamic>(
        METHOD_NAME_INIT_PERSONALIZATION,{});
    return registered as bool;
  }

  @override
  Future<bool> registerInline(WEGInline wegInline) async {
    final registered = await methodChannel.invokeMethod<dynamic>(
        METHOD_NAME_REGISTER_INLINE,
        wegInline.toJSON());
    return registered as bool;
  }

  @override
  Future<bool> deregisterInline(WEGInline wegInline) async {
    final deregistered = await methodChannel.invokeMethod<dynamic>(
        METHOD_NAME_DEREGISTER_INLINE,
        wegInline.toJSON());
    return deregistered as bool;
  }

  Future<bool> autoHandleClick(bool autoHandleClick) async{
    final result = await methodChannel.invokeMethod<dynamic>(
        METHOD_NAME_AUTO_HANDLE_CLICK,
       autoHandleClick);
    return result as bool;
  }

}
