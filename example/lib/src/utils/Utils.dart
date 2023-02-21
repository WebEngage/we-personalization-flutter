import 'dart:convert';

import 'package:flutter_personalization_sdk_example/src/models/customScreen/CustomModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static SharedPreferences? _prefs;

  static initSharedPref() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static var SCREEN_DATA_LIST = "screenDataList";
  static var IS_LOGIN = "isLogin";

  static Future<void> saveScreenDataList(
      List<CustomModel> customModelList) async {
    String screenData = jsonEncode(customModelList
        .map<Map<String, dynamic>>((data) => data.toJson())
        .toList());
    _prefs?.setString(SCREEN_DATA_LIST, screenData);
  }

  static List<CustomModel> getScreenDataList() {
    var data = _prefs?.getString(SCREEN_DATA_LIST);
    if (data != null) {
      return (json.decode(data) as List<dynamic>)
          .map<CustomModel>((item) => CustomModel.fromJson(item))
          .toList();
    }
    return [_defaultCustomModel()];
  }

  static Future<bool> isLogin() async {
    await initSharedPref();
    return _prefs!.getBool(IS_LOGIN) ?? false;
  }

  static void setIsLogin(bool isLogin){
    _prefs?.setBool(IS_LOGIN, isLogin);
  }

  static CustomModel _defaultCustomModel() {
    var model = CustomModel();
    model.screenName = "screen1";
    model.event = "dummy";
    model.listSize = 10;
    model.list = [];
    var data = CustomWidgetData();
    data.screenName = model.screenName;
    data.viewHeight = 100;
    data.viewWidth = 0;
    data.iosPropertyID = 1;
    data.androidPropertyId = "S1P1";
    data.position = 1;
    model.list.add(data);
    return model;
  }

}
