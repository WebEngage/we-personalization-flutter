import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk/WEGPersonalization.dart';
import 'package:flutter_personalization_sdk_example/main.dart';
import 'package:flutter_personalization_sdk_example/src/models/customScreen/CustomModel.dart';
import 'package:flutter_personalization_sdk_example/src/screens/BaseScreen.dart';
import 'package:flutter_personalization_sdk_example/src/screens/CustomScreen.dart';
import 'package:flutter_personalization_sdk_example/src/utils/Logger.dart';
import 'package:flutter_personalization_sdk_example/src/widgets/CustomViewWidget.dart';
import 'package:flutter_personalization_sdk_example/src/widgets/SimpleWidget.dart';
import 'package:webengage_flutter/webengage_flutter.dart';

class CustomListScreen extends StatefulWidget {
  CustomModel customModel;

  CustomListScreen({Key? key, required this.customModel}) : super(key: key);

  @override
  State<CustomListScreen> createState() => _CustomListScreenState();
}

class _CustomListScreenState extends State<CustomListScreen>
    with WEPlaceholderCallback, RouteAware {
  RegExp _numeric = RegExp(r'^-?[0-9]+$');

  /// check if the string contains only numbers
  bool isNumeric(String str) {
    return _numeric.hasMatch(str);
  }

  @override
  void initState() {
    _trackScreen();
    super.initState();
    if (widget.customModel.event.isNotEmpty) {
      WebEngagePlugin.trackEvent(widget.customModel.event);
    }
  }

  void _trackScreen(){
    if ("${widget.customModel.screenAttribute}".isEmpty) {
      WebEngagePlugin.trackScreen(widget.customModel.screenName);
    } else {
      try {
        dynamic value = isNumeric(widget.customModel.screenAttribute) ? int.parse(widget.customModel.screenAttribute)
            : widget.customModel.screenAttribute;

        WebEngagePlugin.trackScreen(widget.customModel.screenName, {
          'Id': value
        });
      }catch(e){
        WebEngagePlugin.trackScreen(widget.customModel.screenName);
      }
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
    WEPersonalization()
        .deregisterWEPlaceholderCallback(widget.customModel.screenName);
    super.dispose();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    _trackScreen();
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
          return CustomInlineScreen(
            isDialog: true,
            hideScreen: widget.customModel.screenName,
          );
        });

    //     });
  }

  double getWidth() {
    var width = MediaQuery.of(context).size.width - 50;
    return width < 0 ? 0 : width;
  }

  double getHeight() {
    var height = MediaQuery.of(context).size.height - 100;
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
            onPressed: () {
              _openDialog();
            },
          )
        ],
      ),
      body: !widget.customModel.isRecycledView
          ? notRecycledView()
          : Container(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                  itemCount: widget.customModel.listSize +
                      widget.customModel.list.length,
                  itemBuilder: (c, i) {
                    int pos = checkIfContains(i);
                    if (pos != -1) {
                      var data = widget.customModel.list[pos];
                      if (data.isCustomView) {
                        return CustomViewWidget(customWidgetData: data);
                      } else {
                        return WEGInlineWidget(
                          screenName: widget.customModel.screenName,
                          androidPropertyId: data.androidPropertyId,
                          iosPropertyId: data.iosPropertyID,
                          viewWidth: data.viewWidth,
                          viewHeight: data.viewHeight,
                          placeholderCallback: this,
                        );
                      }
                    } else {
                      return SimpleWidget(
                        index: i,
                        widgetType:
                            i % 2 == 0 ? WidgetType.image : WidgetType.text,
                      );
                    }
                  })),
    );
  }

  Widget notRecycledView() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: generateChildren(),
        ),
      ),
    );
  }

  List<Widget> generateChildren() {
    var list = <Widget>[];
    list.add(Text("Not Recycled view"));
    int size = widget.customModel.listSize + widget.customModel.list.length;
    for (int i = 0; i < size; i++) {
      int pos = checkIfContains(i);
      if (pos != -1) {
        var data = widget.customModel.list[pos];
        if (data.isCustomView) {
          list.add(CustomViewWidget(customWidgetData: data));
        } else {
          list.add(WEGInlineWidget(
            screenName: widget.customModel.screenName,
            androidPropertyId: data.androidPropertyId,
            iosPropertyId: data.iosPropertyID,
            viewWidth: data.viewWidth,
            viewHeight: data.viewHeight,
            placeholderCallback: this,
          ));
        }
      } else {
        list.add(SimpleWidget(
          index: i,
          widgetType: i % 2 == 0 ? WidgetType.image : WidgetType.text,
        ));
      }
    }
    return list;
  }

  @override
  void onDataReceived(data) {
    super.onDataReceived(data);
    Logger.v("onDataReceived : ${data.toJson()}");
  }

  @override
  void onPlaceholderException(
      String campaignId, String targetViewId, String error) {
    super.onPlaceholderException(campaignId, targetViewId, error);
    Logger.v("onPlaceholderException : $campaignId $targetViewId $error");
  }

  @override
  void onRendered(data) {
    super.onRendered(data);
    Logger.v("onRendered ${data.toJson()}");
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
