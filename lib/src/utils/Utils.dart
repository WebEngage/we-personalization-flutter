import 'package:flutter/services.dart';
import 'package:flutter_personalization_sdk/src/model/WEGInline.dart';
import 'package:flutter_personalization_sdk/src/utils/Constants.dart';

class Utils {
  static final Utils _singleton = Utils._internal();

  factory Utils() {
    return _singleton;
  }

  Utils._internal() {}

  int _currentInlineWidgetIndex = 0;

  int getCurrentNewIndex() {
    return ++_currentInlineWidgetIndex;
  }

  Map<String, dynamic> generateWidgetPayload(
      WEGInline wegInline, double viewWidth, double viewHeight) {
    var map = wegInline.toJSON();
    map.addAll({
      PAYLOAD_VIEW_WIDTH: viewWidth,
      PAYLOAD_VIEW_HEIGHT: viewHeight,
    });
    print("data $map");
    return map;
  }
}
