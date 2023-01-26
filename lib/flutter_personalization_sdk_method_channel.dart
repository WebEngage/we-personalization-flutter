import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_personalization_sdk_platform_interface.dart';

/// An implementation of [FlutterPersonalizationSdkPlatform] that uses method channels.
class MethodChannelFlutterPersonalizationSdk extends FlutterPersonalizationSdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_personalization_sdk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
