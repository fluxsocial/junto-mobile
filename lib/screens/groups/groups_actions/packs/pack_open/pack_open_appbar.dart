
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class PackOpenAppbar extends StatelessWidget {
  const PackOpenAppbar({Key key, @required this.pack}) : super(key: key);

  final dynamic pack;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: <Widget>[Container()],
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
      elevation: 0,
      titleSpacing: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(.75),
        child: Container(
          height: .75,
          decoration: BoxDecoration(color: Theme.of(context).dividerColor),
        ),
      ),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(
                  'My Pack',
                  style: Theme.of(context).textTheme.headline6,
                )
              ],
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 38,
                    color: Colors.transparent,
                    alignment: Alignment.centerRight,
                    child: Icon(CustomIcons.moon,
                        size: 22, color: Theme.of(context).primaryColor),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 38,
                    alignment: Alignment.centerRight,
                    color: Colors.transparent,
                    child: Icon(CustomIcons.morevertical,
                        size: 22, color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
