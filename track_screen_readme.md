
# Track Screen

To track the screen in Flutter, you can use the Flutter Navigator widget and the routes mechanism.

## 1. Push Name
If you are using push name method to navigate to the different screens then use the below method to track screen.

```
Navigator.of(context).pushNamed(SCREEN_NAME);
```

Create a file **ScreenRouteObserver.dart** and add below code

```dart
import 'package:flutter/material.dart';
import 'package:webengage_flutter/webengage_flutter.dart';


class ScreenRouteObserver extends RouteObserver<PageRoute<dynamic>> {

  void _sendScreenView(PageRoute<dynamic> route) {
    var screenName = route.settings.name;
    if (screenName != null) {
        // your code goes here
        WebEngagePlugin.trackScreen(screenName);
    }
  }

  
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _sendScreenView(route);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      _sendScreenView(previousRoute);
    }
  }
}
```

Now in **main.dart** file, create an instance ***ScreenRouteObserver*** class and assign it to navigatorObserver in MaterialApp.

```dart
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: ScreenNavigator.SCREEN_HOME,
      routes: {
        "homeScreen": (context) => const HomeScreen(),
        "detailScreen": (context) => const DetailScreen(),

      },
      navigatorObservers: [ScreenRouteObserver()],
    );
  }
```

## 2. Route Object
If you are using Route method to navigate to the different screens then use the below method to track screen.

```dart
 Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => HomeScreen()));
```

Create a instance of ***RouteObserver*** in **main.dart** file

```dart 
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(const MyApp());
}

```

then add ***routeObserver*** to ***navigatorObservers***

```dart
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: ScreenNavigator.SCREEN_HOME,
      navigatorObservers: [routeObserver],
    );
  }
```

then in your screen widget class do like below 

```dart
class HomeScreen extends StatefulWidget {
  CustomModel customModel;

  HomeScreen({Key? key, required this.customModel}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with RouteAware {

  @override
  void initState() {
    super.initState();
    trackScreen();
  }

   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    super.didPopNext();
    trackScreen();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void trackScreen(){
      WebEngagePlugin.trackScreen("homeScreen");
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HOME SCREEN),
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
    );
  }


```