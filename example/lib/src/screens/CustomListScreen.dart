import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk/WEGPersonalization.dart';
import 'package:flutter_personalization_sdk_example/main.dart';
import 'package:flutter_personalization_sdk_example/src/models/customScreen/CustomModel.dart';
import 'package:flutter_personalization_sdk_example/src/screens/BaseScreen.dart';
import 'package:flutter_personalization_sdk_example/src/screens/CustomScreen.dart';
import 'package:flutter_personalization_sdk_example/src/widgets/SimpleWidget.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class CustomListScreen extends StatefulWidget {
  CustomModel customModel;

  CustomListScreen({Key? key, required this.customModel}) : super(key: key);

  @override
  State<CustomListScreen> createState() => _CustomListScreenState();
}

class _CustomListScreenState extends State<CustomListScreen>
    with WEPlaceholderCallback,RouteAware {
  @override
  void initState() {
    WebEngagePlugin.trackScreen(widget.customModel.screenName);
    super.initState();
    if(widget.customModel.event.isNotEmpty){
      WebEngagePlugin.trackEvent(widget.customModel.event);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }


  @override
  void didPopNext() {
    super.didPopNext();
    WebEngagePlugin.trackScreen(widget.customModel.screenName);
  }

  void _openDialog() {
    print("_openDialog called");
    showModalBottomSheet<void>(
      // context and builder are
      // required properties in this widget
        context: context,
        builder: (BuildContext context) {
          // we set up a container inside which
          // we create center column and display text

          // Returning SizedBox instead of a Container
          return CustomInlineScreen(isDialog: true,);
        });

    // showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         scrollable: true,
    //         title: Text('select next screen'),
    //         content: Container(
    //           width: getWidth(),
    //           height: getHeight(),
    //           child: CustomInlineScreen(isDialog: true,),
    //         ),
    //       );
    //     });
  }

  double getWidth(){
    var width =  MediaQuery.of(context).size.width-50;
    return width < 0 ? 0 : width;
  }

  double getHeight(){
    var height = MediaQuery.of(context).size.height-100;
    return height < 0 ? 0 : height;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.customModel.screenName),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ),
            onPressed: (){
              _openDialog();
            },
          )
        ],
      ),
      body: Container(
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
              itemCount:
                  widget.customModel.listSize + widget.customModel.list.length,
              itemBuilder: (c, i) {
                int pos = checkIfContains(i);
                if (pos != -1) {
                  var data = widget.customModel.list[pos];
                  return WEGInlineWidget(
                    screenName: widget.customModel.screenName,
                    androidPropertyId: data.androidPropertyId,
                    iosPropertyId: data.iosPropertyID,
                    viewWidth: data.viewWidth,
                    viewHeight: data.viewHeight,
                    placeholderCallback: this,
                  );
                } else {
                  return SimpleWidget(
                    index: i,
                    widgetType: i % 2 == 0 ? WidgetType.image : WidgetType.text,
                  );
                }
              })),
    );
  }

  @override
  void onDataReceived(data) {
    super.onDataReceived(data);
  }

  @override
  void onPlaceholderException(String campaignId, String targetViewId, String error) {
    super.onPlaceholderException(campaignId, targetViewId, error);
  }

  @override
  void onRendered(data) {
    super.onRendered(data);
  }

  int checkIfContains(index) {
    var list = widget.customModel.list;
    int count = 0;
    for (var data in list) {
      if (data.position == index) {
        return count;
      }
      count++;
    }
    return -1;
  }
}
