import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk/WEGPersonalization.dart';
import 'package:flutter_personalization_sdk_example/src/observer/RouteObserver.dart';
import 'package:flutter_personalization_sdk_example/src/screens/CustomScreen.dart';
import 'package:flutter_personalization_sdk_example/src/screens/DetailScreen.dart';
import 'package:flutter_personalization_sdk_example/src/screens/HomeScreen.dart';
import 'package:flutter_personalization_sdk_example/src/screens/ListScreen.dart';
import 'package:flutter_personalization_sdk_example/src/utils/AppColor.dart';
import 'package:flutter_personalization_sdk_example/src/utils/ScreenNavigator.dart';
import 'package:flutter_personalization_sdk_example/src/utils/Utils.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

//Route Observer
//https://stackoverflow.com/questions/71279847/flutter-exac-lifecycle-equivalents-to-onresume-onpause-on-android-and-viewwil
class _MyAppState extends State<MyApp> with WECampaignCallback {


  @override
  void initState() {
    super.initState();
    WebEngagePlugin _webenagePlugin = WebEngagePlugin();
    WEPersonalization().init();
    WEPersonalization().registerWECampaignCallback(this);
    WEPersonalization().autoHandleCampaignClick(true);
    initSharedPref();
  }

  void initSharedPref(){
    Utils.initSharedPref();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: ScreenNavigator.SCREEN_HOME,
      routes: {
        ScreenNavigator.SCREEN_HOME: (context) => const HomeScreen(),
        ScreenNavigator.SCREEN_LIST: (context) => const ListScreen(),
        ScreenNavigator.SCREEN_DETAIL: (context) => const DetailScreen(),
        ScreenNavigator.SCREEN_CUSTOM:(context) =>  CustomInlineScreen(isDialog: false,)
      },
      navigatorObservers: [MyRouteObserver(),routeObserver],
    );
  }

  @override
  void onCampaignShown(data) {
    super.onCampaignShown(data);
    print("onCampaignShown $data");
  }

  @override
  void onCampaignClicked(String actionId, String deepLink, data) {
    super.onCampaignClicked(actionId, deepLink, data);
    print("onCampaignClicked $actionId $deepLink $data");
  }

  @override
  void onCampaignPrepared(data) {
    super.onCampaignPrepared(data);
  }

  @override
  void onCampaignException(String? campaignId, String targetViewId, String error) {
    super.onCampaignException(campaignId, targetViewId, error);
    print("onCampaignException $campaignId $targetViewId $error");
  }

}
