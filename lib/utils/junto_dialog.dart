import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/styles.dart';

class JuntoDialog {
  static void showJuntoDialog(
      BuildContext context, String body, List<Widget> actions) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
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
                    style: JuntoStyles.lotusLongformBody,
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
