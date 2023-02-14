import 'dart:convert';

class WECampaignData {
  String? campaignId;
  String? targetViewId;
  WECampaignContent? weCampaignContent;

  WECampaignData();

  WECampaignData.fromJson(dynamic data) {
    if (data != null) {
      var parsedJson = jsonDecode(data);
      campaignId = parsedJson["campaignId"];
      targetViewId = parsedJson["targetViewId"];
      weCampaignContent = WECampaignContent.fromJson(parsedJson["content"]);
    }
  }

}

class WECampaignContent {
  List<WECampaignContent>? children;
  Map<String, dynamic>? customData;
  Map<String, dynamic>? properties;
  String? layoutType;
  String? subLayoutType;

  WECampaignContent();

  WECampaignContent.fromJson(Map<String, dynamic> parsedJson) {
    layoutType = parsedJson["layoutType"] as String?;
    subLayoutType = parsedJson["subLayoutType"] as String?;
    properties = parsedJson["properties"] as Map<String, dynamic>?;
    customData = parsedJson["customData"] as Map<String, dynamic>?;
    var _children = parsedJson["children"];
    if (_children != null) {
      children = <WECampaignContent>[];
      _children.forEach((v) {
        children!.add(WECampaignContent.fromJson(v));
      });
    }
  }
}
