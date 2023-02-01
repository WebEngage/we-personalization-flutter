import 'package:flutter_personalization_sdk/src/model/WECampaignData.dart';

class WECampaignCallback {
  void onCampaignClicked(
      String actionId, String deepLink, WECampaignData data) {}

  void onCampaignException(
      String? campaignId, String targetViewId, String error) {}

  void onCampaignPrepared(WECampaignData data) {}

  void onCampaignShown(WECampaignData data) {}
}
