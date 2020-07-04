import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:flutter/cupertino.dart';

class JuntoInviteAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).backgroundColor,
      iconTheme: IconThemeData(
        color: Theme.of(context).primaryColor,
      ),
      elevation: 0,
      titleSpacing: 0,
      brightness: Theme.of(context).brightness,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                width: 42,
                height: 42,
                alignment: Alignment.centerLeft,
                color: Colors.transparent,
                child: Icon(
                  CustomIcons.back,
                  color: Theme.of(context).primaryColorDark,
                  size: 17,
                ),
              ),
            ),
            Text(
              'Invite',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            const SizedBox(width: 42)
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(.75),
        child: Container(
          height: .75,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).dividerColor,
                width: .75,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
