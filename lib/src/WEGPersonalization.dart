import '../../src/callbacks/WECampaignCallback.dart';
import '../../src/data/data_registry.dart';
import '../../src/flutter_personalization_sdk_platform_interface.dart';
import '../../src/utils/Logger.dart';

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
  
  void enableLogs(){
    Logger.enableLogs(true);
  }

}
