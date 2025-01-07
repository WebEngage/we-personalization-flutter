import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import '../../src/callbacks/we_placeholder_callback.dart';
import '../../src/utils/we_logger.dart';
import '../../src/utils/we_utils.dart';
import '../../src/widget/inline_widget.dart';
import '../model/weg_inline.dart';

class WEInlineWidget extends StatefulWidget {
  final String screenName;
  final String androidPropertyId;
  final int iosPropertyId;
  final double viewWidth;
  final double viewHeight;
  final WEPlaceholderCallback? placeholderCallback;

  const WEInlineWidget(
      {Key? key,
      required this.screenName,
      required this.androidPropertyId,
      required this.iosPropertyId,
      required this.viewWidth,
      required this.viewHeight,
      this.placeholderCallback})
      : super(key: key);

  @override
  State<WEInlineWidget> createState() => _WEInlineWidgetState();
}

class _WEInlineWidgetState extends State<WEInlineWidget>
    with AutomaticKeepAliveClientMixin, WEPlaceholderCallback, EventsSender {
  final GlobalKey _platformViewKey = GlobalKey();
  WEProperty? weProperty;
  var defaultViewHeight = 0.9;
  WEGInlineViewController? controller;
  double viewWidth = 0;

  @override
  void initState() {
    super.initState();
    viewWidth = widget.viewWidth;
    weProperty = WEProperty(
        screenName: widget.screenName,
        androidPropertyID: widget.androidPropertyId,
        iosPropertyId: widget.iosPropertyId,
        wePlaceholderCallback: this);
    weProperty?.eventsSender = this;
  }

  @override
  void dispose() {
    weProperty = null;
    controller = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        if (viewWidth == 0) {
          viewWidth = constraints.maxWidth;
        }
        return SizedBox(
            height: defaultViewHeight,
            child: InlineWidget(
              weProperty: weProperty!,
              key: _platformViewKey,
              payload: Utils().generateWidgetPayload(
                  weProperty!, viewWidth, widget.viewHeight),
              wegInlineHandler: (controller) async {
                this.controller = controller;
              },
            ));
      },
    );
  }

  @override
  void trackClick(Map<String, dynamic> map) {
    super.trackClick(map);
    controller?.trackClick(map);
  }

  @override
  void trackImpression(Map<String, dynamic> map) {
    super.trackImpression(map);
    controller?.trackImpression(map);
  }

  @override
  bool get wantKeepAlive => false;

  @override
  void onDataReceived(data) {
    super.onDataReceived(data);
    if (Platform.isIOS) {
      if (defaultViewHeight != widget.viewHeight && mounted) {
        setState(() {
          defaultViewHeight = widget.viewHeight;
        });
      }
    }
    WELogger.v("WEInlineWidget onDataReceived $data");
    widget.placeholderCallback?.onDataReceived(data);
  }

  @override
  void onPlaceholderException(
      String campaignId, String targetViewId, String error) {
    super.onPlaceholderException(campaignId, targetViewId, error);
    WELogger.v(
        "WEInlineWidget onPlaceholderException $campaignId $targetViewId $error");
    widget.placeholderCallback
        ?.onPlaceholderException(campaignId, targetViewId, error);
  }

  @override
  void onRendered(data) {
    if (defaultViewHeight != widget.viewHeight && mounted) {
      setState(() {
        defaultViewHeight = widget.viewHeight;
      });
    }
    super.onRendered(data);
    WELogger.v("WEInlineWidget onRendered $data");
    widget.placeholderCallback?.onRendered(data);
  }
}
