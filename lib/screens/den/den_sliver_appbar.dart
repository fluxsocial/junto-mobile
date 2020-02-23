import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class JuntoDenSliverAppbar extends StatelessWidget {
  const JuntoDenSliverAppbar(
      {Key key, @required this.name, @required this.currentTheme})
      : super(key: key);

  final String name;
  final String currentTheme;

  String _getBackgroundImageAsset() {
    if (currentTheme == 'rainbow') {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    } else if (currentTheme == 'aqueous') {
      return 'assets/images/junto-mobile__themes--aqueous.png';
    } else if (currentTheme == 'royal') {
      return 'assets/images/junto-mobile__themes--royal.png';
    } else if (currentTheme == 'night') {
      return 'assets/images/junto-mobile__themes--night.png';
    } else {
      return 'assets/images/junto-mobile__themes--rainbow.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      brightness: Brightness.light,
      automaticallyImplyLeading: false,
      primary: false,
      actions: const <Widget>[SizedBox(height: 0, width: 0)],
      backgroundColor: Colors.white,
      pinned: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        background: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .24,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                _getBackgroundImageAsset(),
                height: MediaQuery.of(context).size.height * .24,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * .24,
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const SizedBox(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      expandedHeight: MediaQuery.of(context).size.height * .24,
      forceElevated: false,
    );
  }
}
