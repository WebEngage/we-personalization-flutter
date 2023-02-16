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

class InlineWidget extends StatelessWidget {
  Map<String, dynamic> payload;
  final WEGInlineHandler wegInlineHandler;
  WEGInline wegInline;

  InlineWidget(
      {Key? key,
      required this.wegInlineHandler,
      required this.wegInline,
      required this.payload})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return PlatformViewLink(
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
                creationParams: payload,
                creationParamsCodec: const StandardMessageCodec(),
                onFocus: () {
                  params.onFocusChanged(true);
                },
              )
                ..addOnPlatformViewCreatedListener(params.onPlatformViewCreated)
                ..create();
            });
      case TargetPlatform.iOS:
        return UiKitView(
          viewType: CHANNEL_INLINE_VIEW,
          creationParams: payload,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: _onPlatformViewCreated,
        );
    }

    return const Placeholder();
  }

  void _onPlatformViewCreated(int id) {
    var controller = WEGInlineViewController._(id, wegInline);
    wegInlineHandler(controller);
    controller.setListener();
  }
}

class WEGInlineViewController {
  WEGInlineViewController._(int id, this.wegInline)
      : _channel = MethodChannel('${CHANNEL_INLINE_VIEW}_$id');
  WEGInline wegInline;

  final MethodChannel _channel;

  void impression() {
    _channel.invokeMethod(METHOD_NAME_SEND_IMPRESSION);
  }

  void setListener() {
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  Future _platformCallHandler(MethodCall call) async {
    Logger.v("_platformCallHandler ${call.method} ${wegInline.id}");
    DataRegistry().platformCallHandler(call, wegInline);
  }
}
