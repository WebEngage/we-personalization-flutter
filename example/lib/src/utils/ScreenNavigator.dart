import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk_example/src/screens/HomeScreen.dart';

class ScreenNavigator{

  static const SCREEN_HOME = "screen_home";
  static const SCREEN_LIST = "screen_list";
  static const SCREEN_DETAIL = "screen_detail";

  static void gotoListScreen(context){
    _gotoScreen(context,SCREEN_LIST);
  }

  static void gotoDetailScreen(context){
    _gotoScreen(context,SCREEN_DETAIL);
  }

  static void _gotoScreen(context,SCREEN_NAME){
    Navigator.of(context).pushNamed(SCREEN_NAME);
  }

}