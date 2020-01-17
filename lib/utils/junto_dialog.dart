import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/styles.dart';

class JuntoDialog {
  static void showJuntoDialog(
      BuildContext context, String body, List<Widget> actions,
      [bool barrierDismissible = false]) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        final Brightness brightness = MediaQuery.of(context).platformBrightness;
        return Theme(
          data: ThemeData(dialogBackgroundColor: Colors.white),
          child: Platform.isAndroid
              ? AlertDialog(
                  content: Text(
                    body,
                    style: JuntoStyles.lotusLongformBody,
                  ),
                  actions: <Widget>[
                    if (actions.isNotEmpty) ...actions else const SizedBox(),
                  ],
                )
              : CupertinoAlertDialog(
                  content: Text(
                    body,
                    style: Brightness.dark == brightness
                        ? JuntoStyles.lotusLongformBodyLight
                        : JuntoStyles.lotusLongformBody,
                  ),
                  actions: <Widget>[
                    if (actions.isNotEmpty) ...actions else const SizedBox(),
                  ],
                ),
        );
      },
    );
  }
}

class DialogBack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => Navigator.pop(context),
      child: const Text('Ok'),
    );
  }
}
