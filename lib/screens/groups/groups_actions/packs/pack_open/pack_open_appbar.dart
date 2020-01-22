import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';

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
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 32.0,
                  width: 32.0,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: <double>[0.3, 0.9],
                      colors: <Color>[
                        JuntoPalette.juntoSecondary,
                        JuntoPalette.juntoPrimary,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Transform.translate(
                    offset: const Offset(-1.0, 0),
                    child: const Icon(
                      CustomIcons.packs,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text('My Pack', style: Theme.of(context).textTheme.caption)
              ],
            ),
            Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 42,
                    color: Colors.transparent,
                    alignment: Alignment.centerRight,
                    child: Icon(CustomIcons.moon,
                        size: 22, color: Theme.of(context).primaryColor),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: 42,
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
