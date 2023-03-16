import 'package:flutter_personalization_sdk/src/model/WECampaignData.dart';

class WECampaignCallback {


  /// this method will get called whenever the campaign is clicked,
  /// Any button or view clicked on campaign this method is called and data related to that clicked is received
  /// ** actionId : ID for the view clicked
  /// ** deepLink : if that view contains any deeplink , that linked is passed
  /// ** WECampaignData : campaign data for that complete view
  void onCampaignClicked(
      String actionId, String deepLink, WECampaignData data) {}

  /// this method get called whenever any exception occurred while rendering or action perform
  /// on the campaign view
  void onCampaignException(
      String? campaignId, String targetViewId, String error) {}

  ///whenever the campaign is prepared
  void onCampaignPrepared(WECampaignData data) {}

  /// whenever the campaign is shown
  void onCampaignShown(WECampaignData data) {}
}
