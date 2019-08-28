import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

mixin HideFab {
  void hideFabOnScroll(
      ScrollController controller, ValueNotifier<bool> isVisible) {
    if (controller.position.isScrollingNotifier.value) {
      if (controller.position.userScrollDirection == ScrollDirection.reverse) {
        isVisible.value = false;
      }
      if (controller.position.userScrollDirection == ScrollDirection.forward) {
        isVisible.value = true;
      }
    } else {
      isVisible.value = true;
    }
  }
}
