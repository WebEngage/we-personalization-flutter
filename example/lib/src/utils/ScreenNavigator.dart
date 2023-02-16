import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk_example/src/models/customScreen/CustomModel.dart';
import 'package:flutter_personalization_sdk_example/src/screens/CustomListScreen.dart';
import 'package:flutter_personalization_sdk_example/src/screens/HomeScreen.dart';

class ScreenNavigator {
  static const SCREEN_HOME = "screen_home_1";
  static const SCREEN_LIST = "screen_list";
  static const SCREEN_DETAIL = "screen_detail_123";
  static const SCREEN_CUSTOM = "screen_custom_123";

  static void gotoListScreen(context) {
    _gotoScreen(context, SCREEN_LIST);
  }

  static void gotoDetailScreen(context) {
    _gotoScreen(context, SCREEN_DETAIL);
  }

  static void gotoCustomScreen(context) {
    _gotoScreen(context, SCREEN_CUSTOM);
  }

  static void gotoCustomListScreen(context, CustomModel customModel) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CustomListScreen(customModel: customModel)));
  }

  static void _gotoScreen(context, SCREEN_NAME) {
    Navigator.of(context).pushNamed(SCREEN_NAME);
  }
}
