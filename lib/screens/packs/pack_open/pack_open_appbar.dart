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
        padding: const EdgeInsets.only(right: JuntoStyles.horizontalPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                color: Colors.transparent,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10),
                width: 42,
                child: Icon(
                  CustomIcons.back,
                  color: Theme.of(context).primaryColorDark,
                  size: 17,
                ),
              ),
            ),
            Center(
              child: Text(pack.groupData.name,
                  style: Theme.of(context).textTheme.subhead),
            ),
            GestureDetector(
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: pack.address == ''
                  ? Container(
                      alignment: Alignment.center,
                      height: 32.0,
                      width: 32.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          stops: const <double>[0.3, 0.9],
                          colors: <Color>[
                            JuntoPalette.juntoSecondary,
                            JuntoPalette.juntoPrimary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Transform.translate(
                        offset: Offset(-1.0, 0),
                        child: Icon(
                          CustomIcons.packs,
                          color: Colors.white,
                          size: 14,
                        ),
                      ),
                    )
                  : ClipOval(
                      child: Image.asset(pack.address,
                          height: 32, width: 32, fit: BoxFit.cover),
                    ),
            )
          ],
        ),
      ),

    );
  }
}
