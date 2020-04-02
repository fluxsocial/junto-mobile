import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

class DevicePreviewWrapper extends StatelessWidget {
  final Widget child;

  static Widget appBuilder(
    BuildContext context,
    Widget widget,
  ) {
    if (Platform.isMacOS) {
      return DevicePreview.appBuilder(context, widget);
    } else {
      return widget;
    }
  }

  const DevicePreviewWrapper({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (Platform.isMacOS) {
      return DevicePreview(
        builder: (context) => child,
      );
    } else {
      return child;
    }
  }
}
