import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_personalization_sdk_method_channel.dart';

abstract class FlutterPersonalizationSdkPlatform extends PlatformInterface {
  /// Constructs a FlutterPersonalizationSdkPlatform.
  FlutterPersonalizationSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPersonalizationSdkPlatform _instance = MethodChannelFlutterPersonalizationSdk();

  /// The default instance of [FlutterPersonalizationSdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterPersonalizationSdk].
  static FlutterPersonalizationSdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterPersonalizationSdkPlatform] when
  /// they register themselves.
  static set instance(FlutterPersonalizationSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
