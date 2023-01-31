

import 'package:flutter/material.dart';

class WidgetObserver extends WidgetsBindingObserver {
  GlobalKey platformViewKey;
  var context;
  int count = 0;
  Function onViewAppear;

  WidgetObserver({
    required this.platformViewKey,
    this.context,
    required this.onViewAppear,
  });

  @override
  void didChangeMetrics() {
    final RenderBox renderBox =
        platformViewKey.currentContext?.findRenderObject() as RenderBox;
    final Offset position = renderBox.localToGlobal(Offset.zero);

    if (position.dx >= 0 &&
        position.dy >= 0 &&
        position.dx <= MediaQuery.of(context).size.width &&
        position.dy <= MediaQuery.of(context).size.height) {
      onViewAppear(true);
    } else {
      onViewAppear(false);
    }
  }
}
