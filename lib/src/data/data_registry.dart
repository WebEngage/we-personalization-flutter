import 'package:flutter/services.dart';
import 'package:flutter_personalization_sdk/src/utils/Constants.dart';

import '../callbacks/WEPlaceholderCallback.dart';
import '../flutter_personalization_sdk_platform_interface.dart';
import '../model/WEGInline.dart';

class DataRegistry{
  static final DataRegistry _singleton = DataRegistry._internal();

  factory DataRegistry() {
    return _singleton;
  }

  static const MethodChannel _channel =
  MethodChannel(CHANNEL_PERSONALIZATION);

  DataRegistry._internal(){
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  var mapOfRegistry = <int,WEGInline>{};

  Future<void> registerWEPlaceholderCallback(String propertyId,
      {WEPlaceholderCallback? placeholderCallback}) async{
    WEGInline wegInline = WEGInline(screenName: "", propertyID: propertyId);
    wegInline.wePlaceholderCallback = placeholderCallback;
    registerInlineWidget(wegInline);
  }

  Future<void> registerInlineWidget(WEGInline wegInline) async {
    var success = await FlutterPersonalizationSdkPlatform.instance.registerInline(wegInline);
    if(success){
      mapOfRegistry[wegInline.id] = wegInline;
    }
  }

  Future<void> deregisterInlineWidget(WEGInline wegInline) async {
    var success = await FlutterPersonalizationSdkPlatform.instance.deregisterInline(wegInline);
    if(success){
      mapOfRegistry.remove(wegInline.id);
    }
  }

  void _passDataToWidget(id,payload){
    if(mapOfRegistry.containsKey(id)){
      mapOfRegistry[id]!.callback!(payload);
    }
  }

  void platformCallHandler(MethodCall call){
    _platformCallHandler(call);
  }

  Future _platformCallHandler(MethodCall call) async {
    final methodName = call.method;
    switch(methodName){
      case METHOD_NAME_DATA_LISTENER:
        final data = call.arguments.cast<String, dynamic>();
        final payload = data['payload'];
        final id = payload['id'];
        _passDataToWidget(id, payload);
        break;
      case METHOD_NAME_ON_DATA_RECEIVED:

        final payload = call.arguments.cast<String, dynamic>();
        final data = payload['payload'];
        final id = data['id'];
        var wEGInline = mapOfRegistry[id];
        wEGInline?.wePlaceholderCallback?.onDataReceived(data["data"]);
        break;
      case METHOOD_NAME_ON_PLACEHOLDER_CALLBACK:
        final payload = call.arguments.cast<String, dynamic>();
        final data = payload['payload'];
        final id = data['id'];
        var wEGInline = mapOfRegistry[id];
        wEGInline?.wePlaceholderCallback?.onPlaceholderException(data["campaignId"],
            data["targetViewId"],data["error"]);
        break;
      case METHOD_NAME_ON_RENDERED:
        final payload = call.arguments.cast<String, dynamic>();
        final data = payload['payload'];
        final id = data['id'];
        var wEGInline = mapOfRegistry[id];
        wEGInline?.wePlaceholderCallback?.onRendered(data["data"]);
        break;
    }

  }
}