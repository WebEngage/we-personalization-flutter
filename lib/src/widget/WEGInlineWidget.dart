
import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import '../../src/callbacks/WEPlaceholderCallback.dart';
import '../../src/utils/Utils.dart';
import '../../src/widget/InlineWidget.dart';
import '../model/WEGInline.dart';

class WEGInlineWidget extends StatefulWidget {
  String screenName;
  String androidPropertyId;
  int iosPropertyId;
  double viewWidth;
  double viewHeight;
  WEPlaceholderCallback? placeholderCallback;

  WEGInlineWidget(
      {Key? key,
      required this.screenName,
      required this.androidPropertyId,
      required this.iosPropertyId,
      required this.viewWidth,
      required this.viewHeight,
      this.placeholderCallback})
      : super(key: key);

  @override
  State<WEGInlineWidget> createState() => _WEGInlineWidgetState();
}

class _WEGInlineWidgetState extends State<WEGInlineWidget>
    with AutomaticKeepAliveClientMixin, WEPlaceholderCallback {

  final GlobalKey _platformViewKey = GlobalKey();
  WEGInline? wegInline;
  var defaultViewHeight = 0.1;
  WEGInlineViewController? controller;


  @override
  void initState() {
    super.initState();
    if(Platform.isIOS){
      defaultViewHeight = widget.viewHeight;
    }
    wegInline = WEGInline(
        screenName: widget.screenName,
        androidPropertyID: widget.androidPropertyId,
        iosPropertyId: widget.iosPropertyId,
        wePlaceholderCallback: this);
  }

  @override
  void dispose() {
    wegInline = null;
    widget.placeholderCallback = null;
    controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if(widget.viewWidth == 0){
          widget.viewWidth = constraints.maxWidth;
        }
        return Container(
            height: defaultViewHeight,
            child: InlineWidget(
              wegInline: wegInline!,
              key: _platformViewKey,
              payload: Utils().generateWidgetPayload(
                  wegInline!, widget.viewWidth, widget.viewHeight),
              wegInlineHandler: (controller) async {
                this.controller = controller;
              },
            ));
      },
    );
  }

  @override
  bool get wantKeepAlive => false;

  @override
  void onDataReceived(data) {
    super.onDataReceived(data);
    widget.placeholderCallback?.onDataReceived(data);
  }

  @override
  void onPlaceholderException(
      String campaignId, String targetViewId, String error) {
    super.onPlaceholderException(campaignId, targetViewId, error);
    widget.placeholderCallback
        ?.onPlaceholderException(campaignId, targetViewId, error);
  }

  @override
  void onRendered(data) {
    if (defaultViewHeight != widget.viewHeight) {
      setState(() {
        defaultViewHeight = widget.viewHeight;
      });
    }

    super.onRendered(data);
    widget.placeholderCallback?.onRendered(data);
  }
}
