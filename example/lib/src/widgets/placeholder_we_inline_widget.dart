import 'package:flutter/material.dart';
import 'package:we_personalization_flutter/we_personalization_flutter.dart';

class WEInlineWidgetPlaceholder extends StatefulWidget {
  String screenName;
  String androidPropertyId;
  int iosPropertyId;
  double viewWidth;
  double viewHeight;

  WEInlineWidgetPlaceholder(
      {super.key,
      required this.screenName,
      required this.androidPropertyId,
      required this.iosPropertyId,
      required this.viewWidth,
      required this.viewHeight});

  @override
  State<WEInlineWidgetPlaceholder> createState() =>
      _WEInlineWidgetPlaceholderState();
}

class _WEInlineWidgetPlaceholderState extends State<WEInlineWidgetPlaceholder>
    with WEPlaceholderCallback {
  bool _isRendered = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!_isRendered)
          const Center(
            child: CircularProgressIndicator(), // Placeholder widget
          ),
        WEInlineWidget(
          screenName: widget.screenName,
          androidPropertyId: widget.androidPropertyId,
          iosPropertyId: widget.iosPropertyId,
          viewWidth: widget.viewWidth,
          viewHeight: widget.viewHeight,
          placeholderCallback: this,
        ),
      ],
    );
  }

  @override
  void onRendered(data) {
    super.onRendered(data);
    setState(() {
      _isRendered = true;
    });
  }

  @override
  void onDataReceived(data) {
    super.onDataReceived(data);
    // Handle data received if needed
  }

  @override
  void onPlaceholderException(
      String campaignId, String targetViewId, String error) {
    super.onPlaceholderException(campaignId, targetViewId, error);
    // Handle exceptions if needed
  }
}
