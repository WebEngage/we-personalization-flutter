import 'dart:convert';

import 'package:flutter_personalization_sdk_example/src/models/customScreen/CustomModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Future<void> saveScreenData(CustomModel customModel) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> decode_options = customModel.toJson();
    String screenData = jsonEncode(CustomModel.fromJson(decode_options));
    _prefs.setString('screenData', screenData);
  }

  static Future<CustomModel> getScreenData() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var data = _prefs.getString("screenData");
    print("screen data $data");
    if (data != null) {
      Map<String, dynamic> _map = jsonDecode(data);
      return CustomModel.fromJson(_map);
    }
    return CustomModel();
  }
}
