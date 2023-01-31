import 'package:flutter/material.dart';
import 'package:flutter_personalization_sdk/src/utils/Utils.dart';
import '../../src/callbacks/WEPlaceholderCallback.dart';
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

class _WEGInlineWidgetState extends State<WEGInlineWidget> with AutomaticKeepAliveClientMixin {
  final GlobalKey _platformViewKey = GlobalKey();
  WEGInline? wegInline;
  var defaultViewHeight = 0.1;
  WEGInlineViewController? controller;

  @override
  void initState() {
    super.initState();
    wegInline = WEGInline(
        screenName: widget.screenName,
        androidPropertyID: widget.androidPropertyId,
        iosPropertyId: widget.iosPropertyId,
        wePlaceholderCallback: widget.placeholderCallback);
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
    return Container(
        height: widget.viewHeight,
        color: Colors.blue,
        child: InlineWidget(
          wegInline: wegInline!,
          key: _platformViewKey,
          payload: Utils().generateWidgetPayload(
              wegInline!, widget.viewWidth, widget.viewHeight),
          wegInlineHandler: (controller) async {
            this.controller = controller;
          },
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
