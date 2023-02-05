import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../src/flutter_personalization_sdk_method_channel.dart';
import 'model/WEGInline.dart';

abstract class FlutterPersonalizationSdkPlatform extends PlatformInterface {

  FlutterPersonalizationSdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterPersonalizationSdkPlatform _instance = MethodChannelFlutterPersonalizationSdk();

  static FlutterPersonalizationSdkPlatform get instance => _instance;

  static set instance(FlutterPersonalizationSdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> initPersonalization(){
    throw UnimplementedError('initInline has not been implemented');
  }

  Future<bool> registerInline(WEGInline wegInline){
    throw UnimplementedError('registerPersonalization has not been implemented');
  }

  Future<bool> deregisterInline(WEGInline wegInline){
    throw UnimplementedError('deregisterPersonalization has not been implemented');
  }


}