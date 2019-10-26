import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';

class PackOpenAppbar extends StatelessWidget {
  const PackOpenAppbar({
    Key key,
    @required this.packTitle,
    @required this.packUser,
    @required this.packImage,
  }) : super(key: key);

  final dynamic packTitle;
  final dynamic packUser;
  final dynamic packImage;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      actions: <Widget>[Container()],
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: JuntoStyles.horizontalPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                CustomIcons.back_arrow_left,
                color: JuntoPalette.juntoSleek,
                size: 24,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: Text(packTitle, style: JuntoStyles.title),
            ),
            GestureDetector(
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: ClipOval(
                child: Image.asset(
                  packImage,
                  height: 28.0,
                  width: 28.0,
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
