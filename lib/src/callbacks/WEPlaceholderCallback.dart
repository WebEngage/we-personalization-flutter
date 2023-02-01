import 'package:flutter_personalization_sdk/src/model/WECampaignData.dart';

class WEPlaceholderCallback {

  void onDataReceived(WECampaignData data) {}

  void onPlaceholderException(
      String campaignId, String targetViewId, String error) {}

  void onRendered(WECampaignData data) {}
}
