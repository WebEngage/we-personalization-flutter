import 'package:flutter/services.dart';

import '../../src/callbacks/we_campaign_callback.dart';
import '../../src/model/we_campaign_data.dart';
import '../../src/utils/we_constant.dart';
import '../../src/utils/we_logger.dart';
import '../callbacks/we_placeholder_callback.dart';
import '../flutter_personalization_sdk_platform_interface.dart';
import '../model/weg_inline.dart';

class WEPropertyRegistry {
  static final WEPropertyRegistry _singleton = WEPropertyRegistry._internal();

  factory WEPropertyRegistry() {
    return _singleton;
  }

  static const MethodChannel _channel = MethodChannel(INLINE_SDK_CHANNEL_NAME);

  WEPropertyRegistry._internal() {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  WECampaignCallback? weCampaignCallback;
  var mapOfRegistry = <int, WEProperty>{};

  void registerWECampaignCallback(WECampaignCallback weCampaignCallback) {
    this.weCampaignCallback = weCampaignCallback;
  }

  int registerWEPlaceholderCallback(
      String screenName, String androidPropertyId, int iosPropertyId,
      {WEPlaceholderCallback? placeholderCallback}) {
    WEProperty weProperty = WEProperty(
        screenName: screenName,
        androidPropertyID: androidPropertyId,
        iosPropertyId: iosPropertyId);
    weProperty.wePlaceholderCallback = placeholderCallback;
    registerPlaceholder(weProperty);
    WELogger.v(
        "WEPropertyRegistry register property - ${weProperty.id}, ScreenName : $screenName,Property Id : ($androidPropertyId , $iosPropertyId)");
    return weProperty.id;
  }

  void deRegisterWEPlaceholderCallback(int id) async {
    WELogger.v("WEPropertyRegistry deregister property $id");
    if (mapOfRegistry.containsKey(id)) {
      deregisterPlaceholder(mapOfRegistry[id]!);
    }
  }

  void deRegisterWEPlaceholderCallbackByScreenName(String screenName) async {
    WELogger.v("deRegisterWEPlaceholderCallbackByScreenName - $screenName");
    mapOfRegistry.forEach((key, value) {
      if (value.screenName == screenName) {
        deregisterPlaceholder(value);
      }
    });
  }

  Future<void> registerPlaceholder(WEProperty weProperty) async {
    var success = await WEPSdkPlatform.instance.registerInline(weProperty);
    if (success) {
      mapOfRegistry[weProperty.id] = weProperty;
    }
  }

  Future<void> deregisterPlaceholder(WEProperty weProperty) async {
    WELogger.v(
        "WEPropertyRegistry deregister property with data ${weProperty.toJSON()}");
    var success = await WEPSdkPlatform.instance.deregisterInline(weProperty);
    WELogger.v("WEPropertyRegistry deregister from native = $success");
    if (success) {
      mapOfRegistry.remove(weProperty.id);
    }
  }

  void _passDataToWidget(id, payload) {
    if (mapOfRegistry.containsKey(id)) {
      mapOfRegistry[id]!.callback!(payload);
    }
  }

  // this is for WEInline Widget
  void platformCallHandler(MethodCall call, WEProperty weProperty) {
    WELogger.v(
        " WEPropertyRegistry _platformCallHandler for WEInline Widget ${call.method}");
    _callHandler(call, weProperty);
  }

  // this is for custom view
  Future _platformCallHandler(MethodCall call) async {
    WELogger.v(
        " WEPropertyRegistry _platformCallHandler for Custom View ${call.method}");
    _callHandler(call, null);
  }

  // This method is to handle callback
  Future _callHandler(MethodCall call, WEProperty? weProperty) async {
    final methodName = call.method;
    final data = call.arguments.cast<String, dynamic>();
    final payload = data[PAYLOAD];

    final id = payload[PAYLOAD_ID];
    var wEGInline = weProperty ?? mapOfRegistry[id];

    WELogger.v(
        "WEPropertyRegistry _callHandler $methodName : $id : ${wEGInline?.id} : $data");

    switch (methodName) {
      case METHOD_NAME_DATA_LISTENER:
        _passDataToWidget(id, payload);
        break;
      case METHOD_NAME_ON_DATA_RECEIVED:
        wEGInline?.wePlaceholderCallback?.onDataReceived(
            WECampaignData.fromJson(payload[PAYLOAD_DATA],
                weProperty: wEGInline));
        break;
      case METHOOD_NAME_ON_PLACEHOLDER_CALLBACK:
        var campId = payload[PAYLOAD_CAMPAIGN_ID];
        wEGInline?.wePlaceholderCallback?.onPlaceholderException(
            campId ?? "",
            payload[PAYLOAD_TARGET_VIEW_ID] ?? "",
            payload[PAYLOAD_ERROR] ?? "");
        break;
      case METHOD_NAME_ON_RENDERED:
        wEGInline?.wePlaceholderCallback?.onRendered(WECampaignData.fromJson(
            payload[PAYLOAD_DATA],
            weProperty: wEGInline));
        break;
      case METHOD_NAME_ON_CAMPAIGN_PREPARED:
        weCampaignCallback?.onCampaignPrepared(
            WECampaignData.fromJson(payload[PAYLOAD_DATA]));
        break;
      case METHOD_NAME_ON_CAMPAIGN_EXCEPTION:
        var campaignId = payload[PAYLOAD_CAMPAIGN_ID];
        var targetViewId = payload[PAYLOAD_TARGET_VIEW_ID];
        var error = payload[PAYLOAD_ERROR];
        weCampaignCallback?.onCampaignException(
            campaignId, targetViewId, error);
        break;
      case METHOD_NAME_ON_CAMPAIGN_SHOWN:
        weCampaignCallback
            ?.onCampaignShown(WECampaignData.fromJson(payload[PAYLOAD_DATA]));
        break;
      case METHOD_NAME_ON_CAMPAIGN_CLICKED:
        var actionId = payload[PAYLOAD_ACTION_ID];
        var deepLink = payload[PAYLOAD_DEEPLINK];
        weCampaignCallback?.onCampaignClicked(
            actionId, deepLink, WECampaignData.fromJson(payload[PAYLOAD_DATA]));
        break;
    }
  }
}
