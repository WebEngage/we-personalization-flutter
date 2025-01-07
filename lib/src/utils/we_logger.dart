import 'package:flutter/foundation.dart';

class WELogger {
  static bool _enableLogs = false;

  static void enableLogs(bool enable){
    _enableLogs = enable;
  }

  static void v(String text) {
    if (_enableLogs) {
      _printVerbose(getFormattedText(text));
    }
  }

  static void e(String text) {
    if (_enableLogs) {
      _printError(getFormattedText(text));
    }
  }

  static void w(String text) {
    if (_enableLogs) {
      _printWarning(getFormattedText(text));
    }
  }

  static String getFormattedText(text){
    return "WEP H $text";
  }

  static void _printVerbose(String text) {
    if (kDebugMode) {
      print(text);
    }
  }

  static void _printWarning(String text) {
    if (kDebugMode) {
      print(text);
    }
  }

  static void _printError(String text) {
    if (kDebugMode) {
      print(text);
    }
  }
}
