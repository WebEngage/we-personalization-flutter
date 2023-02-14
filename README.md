
# WebEngage Personalization for Flutter

This repository contains the source code for the WebEngage Personalization Flutter plugin.

### Get Started
add depencency in pubspec.yaml

```dart
//TODO
```

### Initialize

In **main.dart** file after initializing WebEngage plugin , Initialize personalization plugin

```dart
import 'package:flutter_personalization_sdk/WEGPersonalization.dart';

WEPersonalization().init();

```

Before adding WEPersonalization widget into screens, please follow the screen tracking documentation.

Add ***WEGInlineWidget*** widget in your widget like below

```dart
WEGInlineWidget(
        screenName: ,//the name you pass during the trackScreen
        androidPropertyId: ,//Android Property ID
        iosPropertyId: ,//IOS Property ID
        viewWidth: ,// width of view - if pass 0 it will take whole parent  width
        viewHeight: ,// height of view 
        placeholderCallback: this,// callback 
                  );
```

implement ***placeholderCallback***

In your class where you have added WEGPersonalization implement it with ***WEPlaceholderCallback*** and override the methods


```dart
class _HomeScreenState extends State<HomeScreen>
    with WEPlaceholderCallback{


    @override
    void onDataReceived(data) {
        super.onDataReceived(data);
    }

    @override
    void onPlaceholderException(String campaignId, String targetViewId,     String error) {
        super.onPlaceholderException(campaignId, targetViewId, error);
    }
  
    @override
    void onRendered(data) {
        super.onRendered(data);
     }

    }
```

To implement ***WEGInlineWidget*** without view

add below code after ***initState*** methods

```dart
WEPersonalization().registerWEPlaceholderCallback(androidPropertyId, iosPropertyId, screenName);
```

and in ***dispose*** method add below line

```dart
WEPersonalization().deregisterWEPlaceholderCallback(screenName);
```


If you want the personalization sdk should handle the click events ,
then add the below line after init of personalization sdk inside ***main.dart*** file

```dart
// by default its value is false
 WEPersonalization().autoHandleCampaignClick(true);
```

if you want campaign click events response the add below line in main.dart file after ***autoHandleCampaignClick*** method

```dart
 WEPersonalization().registerWECampaignCallback(this);
```

```dart
class _MyAppState extends State<MyApp> with WECampaignCallback {

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
```





