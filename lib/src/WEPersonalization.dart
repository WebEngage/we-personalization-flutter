import '../../src/callbacks/WECampaignCallback.dart';
import '../../src/data/data_registry.dart';
import '../../src/flutter_personalization_sdk_platform_interface.dart';
import '../../src/utils/WELogger.dart';

import 'callbacks/WEPlaceholderCallback.dart';

class WEPersonalization {
  static final WEPersonalization _singleton = WEPersonalization._internal();

  factory WEPersonalization() {
    return _singleton;
  }

  WEPersonalization._internal();

  void init({bool enableLogs = false}) {
    WELogger.enableLogs(enableLogs);
    WEPSdkPlatform.instance.initPersonalization();
  }

  /// use this method to register if you only wanted to get the data and not
  /// the ui rendering part
  /// example : Custom view
  int registerWEPlaceholderCallback(
      String? androidPropertyId, int iosPropertyId, String screenName,
      {WEPlaceholderCallback? placeholderCallback}) {
    return WEPropertyRegistry().registerWEPlaceholderCallback(
        screenName, androidPropertyId!, iosPropertyId,
        placeholderCallback: placeholderCallback);
  }

  /// use this method to get the callback for any action perform on campaign
  void registerWECampaignCallback(WECampaignCallback weCampaignCallback) {
    WEPropertyRegistry().registerWECampaignCallback(weCampaignCallback);
  }

  void deregisterWEPlaceholderCallback(String screenName) {
    WEPropertyRegistry()
        .deRegisterWEPlaceholderCallbackByScreenName(screenName);
  }

  void deregisterWEPlaceholderCallbackById(int ID) {
    WEPropertyRegistry().deRegisterWEPlaceholderCallback(ID);
  }

}
