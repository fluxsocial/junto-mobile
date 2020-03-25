import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

mixin HideFab {
  bool hideOrShowFab(ScrollUpdateNotification value, ValueNotifier isVisible) {
    if (value.metrics.axis == Axis.vertical) {
      if (value.scrollDelta > 10 && value.metrics.pixels > 0) {
        isVisible.value = false;
      } else if (value.scrollDelta <= 0) {
        isVisible.value = true;
      }
    }
    return false;
  }
}
