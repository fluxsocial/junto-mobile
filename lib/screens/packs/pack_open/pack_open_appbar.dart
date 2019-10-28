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
                child: const Icon(
                  CustomIcons.back,
                  color: JuntoPalette.juntoGrey,
                  size: 17,
                ),
              ),
            ),
            Center(
              child: Text(
                packTitle,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff333333),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
              // child: ClipOval(
              //   child: Image.asset(
              //     packImage,
              //     height: 28.0,
              //     width: 28.0,
              //     fit: BoxFit.cover,
              //   ),
              // ),
              child: Container(
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
              ),
            )
          ],
        ),
      ),
    );
  }
}
