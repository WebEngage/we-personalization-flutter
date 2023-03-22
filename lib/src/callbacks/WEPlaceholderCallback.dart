import 'package:we_personalization_flutter/src/model/WECampaignData.dart';

class WEPlaceholderCallback {

  /// In WeCampaignData you will receive all the data related to the UI
  void onDataReceived(WECampaignData data) {}

  /// In PlaceholderException , you will get the exception related to ui rendering
  /// if due to any reason ui is not been rendered, the exception will thrown here
  /// and the ui will not rendered
  /// ex : due to timeout exception ui not rendered you will get the below exception
  /// * Campaign failed to rendered in set time
  void onPlaceholderException(
      String campaignId, String targetViewId, String error) {}

  /// This method will get called whenever the Campaign rendering get completed.
  /// you will all the data related to ui in WECampaignData.
  void onRendered(WECampaignData data) {}
}
