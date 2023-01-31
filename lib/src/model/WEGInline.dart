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

  WEGInline(
      {required this.screenName,
      required this.iosPropertyId,
      required this.androidPropertyID,
      this.callback,
      this.wePlaceholderCallback}) {
    id = Utils().getCurrentNewIndex();
  }

  Map<String,dynamic> toJSON() {
    return {
      PAYLOAD_ID: id,
      PAYLOAD_SCREEN_NAME: screenName,
      PAYLOAD_ANDROID_PROPERTY_ID: androidPropertyID,
      PAYLOAD_IOS_PROPERTY_ID:iosPropertyId
    };
  }
}
