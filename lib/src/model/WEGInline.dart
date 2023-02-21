import 'package:flutter_personalization_sdk/src/flutter_personalization_sdk_platform_interface.dart';

import '../../src/utils/Constants.dart';

import '../callbacks/WEPlaceholderCallback.dart';
import '../utils/Utils.dart';

class WEGInline {
  int id = -1;
  String screenName;
  String androidPropertyID;
  int iosPropertyId;
  Function? callback;
  WEPlaceholderCallback? wePlaceholderCallback;
  EventsSender? eventsSender;

  void trackImpression(Map<String, dynamic> map) {
    if (eventsSender == null) {
      FlutterPersonalizationSdkPlatform.instance.trackImpression(this, map);
    }
    eventsSender?.trackImpression(map);
  }

  void trackClick(Map<String, dynamic> map) {
    if (eventsSender == null) {
      FlutterPersonalizationSdkPlatform.instance.trackClick(this, map);
    }
    eventsSender?.trackClick(map);
  }

  WEGInline(
      {required this.screenName,
      required this.iosPropertyId,
      required this.androidPropertyID,
      this.callback,
      this.wePlaceholderCallback}) {
    id = Utils().getCurrentNewIndex();
  }

  Map<String, dynamic> toJSON() {
    return {
      PAYLOAD_ID: id,
      PAYLOAD_SCREEN_NAME: screenName,
      PAYLOAD_ANDROID_PROPERTY_ID: androidPropertyID,
      PAYLOAD_IOS_PROPERTY_ID: iosPropertyId
    };
  }
}

class EventsSender {
  void trackImpression(Map<String, dynamic> map) {}

  void trackClick(Map<String, dynamic> map) {}
}
