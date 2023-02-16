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

  Map toJson() {
    var map = {
      "campaignId" : campaignId,
      "targetViewId" : targetViewId,
      "content" : weCampaignContent?.toJson()
    };
    return map;
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

  Map toJson() {
    var map = {
      "layoutType": layoutType,
      "subLayoutType": subLayoutType,
      "properties": properties,
      "customData": customData,
      "children": children?.map((e) => e.toJson()).toList()
    };
    return map;
  }
}
