import 'package:flutter/services.dart';
import '../../src/model/WEGInline.dart';
import '../../src/utils/Constants.dart';

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
      WEProperty weProperty, double viewWidth, double viewHeight) {
    var map = weProperty.toJSON();
    map.addAll({
      PAYLOAD_VIEW_WIDTH: viewWidth,
      PAYLOAD_VIEW_HEIGHT: viewHeight,
    });
    return map;
  }
}
