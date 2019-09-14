import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/styles.dart';

class JuntoDialog {
  static void showJuntoDialog(
      BuildContext context, String heading, String body, List<Widget> actions) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: <Widget>[
                const CircleAvatar(
                  backgroundImage: AssetImage(
                    'assets/images/junto-mobile__logo.png',
                  ),
                  radius: 20.0,
                  backgroundColor: Colors.white,
                ),
                const SizedBox(width: 12.0),
                Text(heading, style: JuntoStyles.perspectiveTitle),
              ],
            ),
          ),
          content: Text(
            body,
            style: JuntoStyles.lotusLongformBody,
          ),
          actions: <Widget>[
            if (actions.isNotEmpty) ...actions else const SizedBox(),
          ],
        );
      },
    );
  }
}
