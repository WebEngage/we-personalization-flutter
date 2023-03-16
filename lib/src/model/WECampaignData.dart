import 'dart:convert';

import 'package:flutter_personalization_sdk/src/model/WEGInline.dart';

class WECampaignData {
  String? campaignId;
  String? targetViewId;
  WECampaignContent? weCampaignContent;
  WEGInline? _wegInline;

  WECampaignData();

  WECampaignData.fromJson(dynamic data,{WEGInline? wegInline}) {
    if (data != null) {
      var parsedJson = jsonDecode(data);
      campaignId = parsedJson["campaignId"];
      targetViewId = parsedJson["targetViewId"];
      weCampaignContent = WECampaignContent.fromJson(parsedJson["content"]);
      _wegInline = wegInline;
    }
  }


  void trackImpression({Map<String, dynamic> map = const {}}){
    print("tracked object ${_wegInline != null}");
    _wegInline?.trackImpression(map);
  }

  void trackClick({Map<String, dynamic> map = const {}}){
    _wegInline?.trackClick(map);
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
