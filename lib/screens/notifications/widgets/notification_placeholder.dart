import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';

class NotificationPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Transform.translate(
        offset: Offset(0.0, -50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/junto-mobile__placeholder--notifications.png',
              height: MediaQuery.of(context).size.height * .15,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 20),
            Text(
              S.of(context).notifications_nothing_new_yet,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
