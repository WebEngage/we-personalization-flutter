import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../src/data/data_registry.dart';
import '../../src/model/weg_inline.dart';
import '../../src/utils/we_constant.dart';
import '../../src/utils/we_logger.dart';

typedef WEGInlineHandler = void Function(WEGInlineViewController controller);

class InlineWidget extends StatefulWidget {
  final Map<String, dynamic> payload;
  final WEGInlineHandler wegInlineHandler;
  final WEProperty weProperty;

  const InlineWidget(
      {key,
      required this.wegInlineHandler,
      required this.weProperty,
      required this.payload})
      : super(key: key);

  @override
  State<InlineWidget> createState() => _InlineWidgetState();
}

class _InlineWidgetState extends State<InlineWidget> {
  var height = 0.0;
  var width = 0.0;
  var elevation = 0.0;
  var roundedCorners = 0.0;
  var margin = {"ml": 0.0, "mr": 0.0, "mt": 0.0, "mb": 0.0};

  @override
  void initState() {
    super.initState();
  }

  int count = 0;

  double getMargin(margin, minus) {
    var value = margin - minus;
    if (value < 0) return margin;
    return margin;
  }

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return buildAndroidView();
      case TargetPlatform.iOS:
        return buildIOSView();
      default:
        return const Placeholder();
    }
  }

  Widget buildAndroidView() => Center(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: margin["mt"]!.toDouble(),
                bottom: margin["mb"]!.toDouble(),
                //left: margin["ml"]!.toDouble(),
                // right: margin["mr"]!.toDouble(),
              ),
              width: width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(roundedCorners),
                boxShadow: [
                  BoxShadow(
                    color: elevation == 0
                        ? Colors.transparent
                        : Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: const Offset(1.0, 2.0),
                  ),
                ],
              ),
            ),
            PlatformViewLink(
                viewType: CHANNEL_INLINE_VIEW,
                surfaceFactory: (context, controller) {
                  return AndroidViewSurface(
                    controller: controller as AndroidViewController,
                    gestureRecognizers: const <Factory<
                        OneSequenceGestureRecognizer>>{},
                    hitTestBehavior: PlatformViewHitTestBehavior.opaque,
                  );
                },
                onCreatePlatformView: (params) {
                  _onPlatformViewCreated(params.id);
                  return PlatformViewsService.initSurfaceAndroidView(
                    id: params.id,
                    viewType: CHANNEL_INLINE_VIEW,
                    layoutDirection: TextDirection.ltr,
                    creationParams: widget.payload,
                    creationParamsCodec: const StandardMessageCodec(),
                    onFocus: () {
                      params.onFocusChanged(true);
                    },
                  )
                    ..addOnPlatformViewCreatedListener(
                        params.onPlatformViewCreated)
                    ..create();
                }),
          ],
        ),
      );

  Widget buildIOSView() => UiKitView(
        viewType: CHANNEL_INLINE_VIEW,
        creationParams: widget.payload,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: _onPlatformViewCreated,
      );

  void _onPlatformViewCreated(int id) {
    var controller = WEGInlineViewController._(id, widget.weProperty, update);
    widget.wegInlineHandler(controller);
    controller.setListener();
  }

  void update(int e, int rc, bool reset, margin_, other) {
    try {
      if (reset) {
        setState(() {
          elevation = 0;
          roundedCorners = 0;
        });
        return;
      } else {
        margin = margin_;
        width = other["w"].toDouble();
        height = other["h"].toDouble();
        setState(() {
          elevation = e.toDouble();
          roundedCorners = rc.toDouble();
        });
      }
    } catch (e) {
      WELogger.e("Exception update _platformCallHandler ${e.toString()}");
    }
  }
}

class WEGInlineViewController {
  WEGInlineViewController._(int id, this.weProperty, this.update)
      : _channel = MethodChannel('${CHANNEL_INLINE_VIEW}_$id');
  WEProperty weProperty;

  final MethodChannel _channel;
  Function update;

  void trackImpression(Map<String, dynamic> map) {
    _channel.invokeMethod(METHOD_NAME_SEND_IMPRESSION, map);
  }

  void trackClick(Map<String, dynamic> map) {
    _channel.invokeMethod(METHOD_NAME_SEND_CLICK, map);
  }

  void setListener() {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  Future _platformCallHandler(MethodCall call) async {
    if (Platform.isAndroid) {
      WELogger.v(
          "InlineWidget _platformCallHandler ${call.method} ${call.arguments}");
      if (call.method == METHOD_NAME_RESET_SHADOW_DETAILS) {
        update(0, 0, true, 0, {});
        return;
      }
      if (call.method == METHOD_NAME_ON_RENDERED) {
        try {
          var argument = call.arguments.cast<String, dynamic>()[PAYLOAD]
              [PAYLOAD_SHADOW_DATA];
          if ((argument as Map).isNotEmpty) {
            var e = argument["elevation"];
            var rc = argument["corners"];
            var other = {"w": argument["w"], "h": argument["h"]};
            var margin = <String, double>{};
            margin = {
              "ml": argument["ml"].toDouble(),
              "mr": argument["mr"].toDouble(),
              "mt": argument["mt"].toDouble(),
              "mb": argument["mb"].toDouble()
            };
            WELogger.v("InlineWidget _platformCallHandler2 $argument");
            Future.delayed(const Duration(milliseconds: 250), () {
              update(e, rc, false, margin, other);
            });
          }
        } catch (e) {
          WELogger.e("Exception Hybrid _platformCallHandler ${e.toString()}");
        }
      }
    }
    WEPropertyRegistry().platformCallHandler(call, weProperty);
  }
}
