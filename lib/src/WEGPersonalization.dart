import 'package:flutter_personalization_sdk/src/callbacks/WECampaignCallback.dart';
import 'package:flutter_personalization_sdk/src/data/data_registry.dart';
import 'package:flutter_personalization_sdk/src/flutter_personalization_sdk_platform_interface.dart';

import 'callbacks/WEPlaceholderCallback.dart';

class WEPersonalization {
  static final WEPersonalization _singleton = WEPersonalization._internal();

  factory WEPersonalization() {
    return _singleton;
  }

  WEPersonalization._internal();

  void init() {
    FlutterPersonalizationSdkPlatform.instance.initPersonalization();
  }

  void registerWEPlaceholderCallback(
      String? androidPropertyId, int iosPropertyId, String screenName,
      {WEPlaceholderCallback? placeholderCallback}) async {
    DataRegistry().registerWEPlaceholderCallback(
        screenName, androidPropertyId!, iosPropertyId,
        placeholderCallback: placeholderCallback);
  }

  void registerWECampaignCallback(WECampaignCallback weCampaignCallback) {
    DataRegistry().registerWECampaignCallback(weCampaignCallback);
  }

  void deregisterWEPlaceholderCallback(String screenName) {
    DataRegistry().deRegisterWEPlaceholderCallbackByScreenName(screenName);
  }

  void autoHandleCampaignClick(bool auto){
    DataRegistry().autoHandleClick(auto);
  }

}
