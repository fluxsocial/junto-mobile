import 'package:flutter/material.dart';

/// Custom ScrollBehaviour which returns the `child` directly without
/// an overscroll glow
class PlainScrollBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
    BuildContext context,
    Widget child,
    AxisDirection axisDirection,
  ) {
    return child;
  }
}
