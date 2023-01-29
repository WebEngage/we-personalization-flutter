import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk_example/src/observer/RouteObserver.dart';
import 'package:flutter_personalization_sdk_example/src/screens/CustomScreen.dart';
import 'package:flutter_personalization_sdk_example/src/screens/DetailScreen.dart';
import 'package:flutter_personalization_sdk_example/src/screens/HomeScreen.dart';
import 'package:flutter_personalization_sdk_example/src/screens/ListScreen.dart';
import 'package:flutter_personalization_sdk_example/src/utils/AppColor.dart';
import 'package:flutter_personalization_sdk_example/src/utils/ScreenNavigator.dart';

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
//https://stackoverflow.com/questions/71279847/flutter-exact-lifecycle-equivalents-to-onresume-onpause-on-android-and-viewwil
class _MyAppState extends State<MyApp> {
  // final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: ScreenNavigator.SCREEN_HOME,
      routes: {
        ScreenNavigator.SCREEN_HOME: (context) => const HomeScreen(),
        ScreenNavigator.SCREEN_LIST: (context) => const ListScreen(),
        ScreenNavigator.SCREEN_DETAIL: (context) => const DetailScreen(),
        ScreenNavigator.SCREEN_CUSTOM:(context) => const CustomInlineScreen()
      },
      navigatorObservers: [MyRouteObserver()],
    );
  }
}
