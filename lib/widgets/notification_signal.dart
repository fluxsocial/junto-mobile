import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:provider/provider.dart';

class NotificationSignal extends StatelessWidget {
  const NotificationSignal({
    this.top,
    this.right,
  });

  final double top;
  final double right;

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return Positioned(
        top: top,
        right: right,
        child: Container(
          height: 7,
          width: 7,
          decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      );
    });
  }
}
