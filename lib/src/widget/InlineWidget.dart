import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../../src/data/data_registry.dart';
import '../../src/model/WEGInline.dart';
import '../../src/utils/Constants.dart';
import '../../src/utils/Logger.dart';

typedef WEGInlineHandler = void Function(WEGInlineViewController controller);

class InlineWidget extends StatefulWidget {
  Map<String, dynamic> payload;
  final WEGInlineHandler wegInlineHandler;
  WEGInline wegInline;

//6dp shadow 50dp corner
  InlineWidget(
      {Key? key,
      required this.wegInlineHandler,
      required this.wegInline,
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    height = widget.payload[PAYLOAD_VIEW_HEIGHT];
    width = widget.payload[PAYLOAD_VIEW_WIDTH];
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 5),
              width: width < 0 ? 0 : width,
              height: height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(roundedCorners),
                boxShadow: [
                  BoxShadow(
                    color: elevation == 0 ?  Colors.transparent : Colors.grey.withOpacity(0.9),
                    blurRadius: elevation,
                    offset: const Offset(0.0, 3.5),
                  ),
                ],
              ),
            ),
            PlatformViewLink(
                viewType: CHANNEL_INLINE_VIEW,
                surfaceFactory: (context, controller) {
                  return AndroidViewSurface(
                    controller: controller as AndroidViewController,
                    gestureRecognizers: const <
                        Factory<OneSequenceGestureRecognizer>>{},
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
        );
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: CHANNEL_INLINE_VIEW,
          creationParams: widget.payload,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: _onPlatformViewCreated,
        );
    }

    return const Placeholder();
  }

  void _onPlatformViewCreated(int id) {
    var controller = WEGInlineViewController._(id, widget.wegInline, update);
    widget.wegInlineHandler(controller);
    controller.setListener();
  }

  void update(int w, int h, int e, int rc,bool reset) {
    try {
      if (reset) {
        setState(() {
          elevation = 0;
          roundedCorners = 0;
        });
        return;
      } else {
        width = w.toDouble();
        height = h.toDouble() + 5;
        setState(() {
          elevation = e.toDouble();
          roundedCorners = rc.toDouble();
        });
      }
    }catch(e){
      print("Exception update ${e.toString()}");
    }
  }
}

class WEGInlineViewController {
  WEGInlineViewController._(int id, this.wegInline, this.update)
      : _channel = MethodChannel('${CHANNEL_INLINE_VIEW}_$id');
  WEGInline wegInline;

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
    Logger.v("_platformCallHandler ${call.method} ${wegInline.id}");
    if (call.method == METHOD_NAME_SEND_SHADOW_DETAILS) {
      try {
        var argument = call.arguments.cast<String, dynamic>()[PAYLOAD];
        var w = argument["width"];
        var h = argument["height"];
        var e = argument["elevation"];
        var rc = argument["corners"];
        if (w != 0 && h != 0) {
          update(w, h, e, rc, false);
        }
      }catch(e){
        print("Exception Hybrid _platformCallHandler ${e.toString()}");
      }
    }if(call.method == METHOD_NAME_RESET_SHADOW_DETAILS){
      update(0,0,0,0,true);
    } else {
      DataRegistry().platformCallHandler(call, wegInline);
    }
  }
}
