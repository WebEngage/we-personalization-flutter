import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk/WEGPersonalization.dart';
import 'package:flutter_personalization_sdk/src/model/WECampaignData.dart';
import 'package:flutter_personalization_sdk_example/src/widgets/customWidgets/Button.dart';
import '../../src/models/customScreen/CustomModel.dart';

class CustomViewWidget extends StatefulWidget {
  CustomWidgetData customWidgetData;

  CustomViewWidget({Key? key, required this.customWidgetData})
      : super(key: key);

  @override
  State<CustomViewWidget> createState() => _CustomViewWidgetState();
}

class _CustomViewWidgetState extends State<CustomViewWidget>
    implements WEPlaceholderCallback {
  var _onDataReceived = "";
  var id = -1;
  WECampaignData? weCampaignData;
  int count = 0;

  @override
  void initState() {
    super.initState();
    id = WEPersonalization().registerWEPlaceholderCallback(
        widget.customWidgetData.androidPropertyId,
        widget.customWidgetData.iosPropertyID,
        widget.customWidgetData.screenName,
        placeholderCallback: this);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      height: 150,
      decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Custom View count : ${count}"),
          Text(
              "Property ID : ${Platform.isAndroid ? widget.customWidgetData.androidPropertyId : widget.customWidgetData.iosPropertyID}"),
          Expanded(child: Text("On Data Received - ${_onDataReceived}")),
          _onDataReceived.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomWidgets.button2("Impression", () {
                      weCampaignData?.trackImpression({"1":1});
                    }),
                    CustomWidgets.button2("click", () {
                      weCampaignData?.trackClick({"2":2});
                    })
                  ],
                )
              : SizedBox()
        ],
      ),
    );
  }

  @override
  void onDataReceived(WECampaignData data) {
    ++count;
    weCampaignData = data;
    setState(() {
      _onDataReceived = "${data.toJson()}";
    });
  }

  @override
  void dispose() {
    if (id != -1) {
      WEPersonalization().deregisterWEPlaceholderCallbackById(id);
    }
    super.dispose();
  }

  @override
  void onPlaceholderException(
      String campaignId, String targetViewId, String error) {
    setState(() {
      _onDataReceived = "onPlaceholderException $error";
    });
  }

  @override
  void onRendered(WECampaignData data) {}
}
