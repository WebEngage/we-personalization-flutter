import 'package:flutter/services.dart';
import 'package:flutter_personalization_sdk/src/utils/Constants.dart';

import '../callbacks/WEPlaceholderCallback.dart';
import '../flutter_personalization_sdk_platform_interface.dart';
import '../model/WEGInline.dart';

class DataRegistry {
  static final DataRegistry _singleton = DataRegistry._internal();

  factory DataRegistry() {
    return _singleton;
  }

  static const MethodChannel _channel = MethodChannel(CHANNEL_PERSONALIZATION);

  DataRegistry._internal() {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  var mapOfRegistry = <int, WEGInline>{};

  int registerWEPlaceholderCallback(
      String screenName,
      String androidPropertyId,
      int iosPropertyId,
      {WEPlaceholderCallback? placeholderCallback}) {
    WEGInline wegInline =
        WEGInline(screenName: screenName, androidPropertyID: androidPropertyId,
        iosPropertyId: iosPropertyId
        );
    wegInline.wePlaceholderCallback = placeholderCallback;
    registerInlineWidget(wegInline);
    return wegInline.id;
  }

  void deRegisterWEPlaceholderCallback(int id) async {
    mapOfRegistry.remove(id);
  }

  Future<void> registerInlineWidget(WEGInline wegInline) async {
    var success = await FlutterPersonalizationSdkPlatform.instance
        .registerInline(wegInline);
    if (success) {
      mapOfRegistry[wegInline.id] = wegInline;
    }
  }

  Future<void> deregisterInlineWidget(WEGInline wegInline) async {
    var success = await FlutterPersonalizationSdkPlatform.instance
        .deregisterInline(wegInline);
    if (success) {
      mapOfRegistry.remove(wegInline.id);
    }
  }

  void _passDataToWidget(id, payload) {
    if (mapOfRegistry.containsKey(id)) {
      mapOfRegistry[id]!.callback!(payload);
    }
  }

  void platformCallHandler(MethodCall call, WEGInline wegInline) {
    _callHandler(call,wegInline);
  }

  Future _platformCallHandler(MethodCall call) async {
    _callHandler(call, null);
  }

  Future _callHandler(MethodCall call,WEGInline? wegInline) async {
    final methodName = call.method;
    final data = call.arguments.cast<String, dynamic>();
    final payload = data['payload'];
    final id = payload['id'];
    var wEGInline = wegInline ?? mapOfRegistry[id];
    switch (methodName) {
      case METHOD_NAME_DATA_LISTENER:
        _passDataToWidget(id, payload);
        break;
      case METHOD_NAME_ON_DATA_RECEIVED:
        wEGInline?.wePlaceholderCallback?.onDataReceived(payload["data"]);
        break;
      case METHOOD_NAME_ON_PLACEHOLDER_CALLBACK:
        wEGInline?.wePlaceholderCallback?.onPlaceholderException(
            payload["campaignId"], payload["targetViewId"], payload["error"]);
        break;
      case METHOD_NAME_ON_RENDERED:
        wEGInline?.wePlaceholderCallback?.onRendered(payload["data"]);
        break;
    }
  }

}
