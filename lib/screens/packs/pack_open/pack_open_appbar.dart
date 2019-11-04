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
                child:
                    Text(packTitle, style: Theme.of(context).textTheme.subhead),
              ),
              GestureDetector(
                onTap: () {
                  Scaffold.of(context).openEndDrawer();
                },

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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(.75),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).dividerColor, width: .75),
              ),
            ),
          ),
        ));
  }
}
