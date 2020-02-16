import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/global_search/global_search.dart';
import 'package:junto_beta_mobile/screens/notification/notification_screen.dart';

// Junto app bar used in collective screen.
class CollectiveAppBar extends SliverPersistentHeaderDelegate {
  CollectiveAppBar(
      {@required this.expandedHeight,
      this.degrees,
      this.currentDegree,
      this.switchDegree,
      this.appbarTitle,
      this.openPerspectivesDrawer});

  final double expandedHeight;
  final String appbarTitle;
  final Function openPerspectivesDrawer;
  final bool degrees;
  final String currentDegree;
  final Function switchDegree;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: degrees == true ? 135 : 85,
      child: Column(
        children: <Widget>[
          Container(
            height: 85,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
                color: Theme.of(context).backgroundColor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    openPerspectivesDrawer();
                  },
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.only(left: 10),
                    color: Colors.transparent,
                    height: 36,
                    child: Row(
                      children: <Widget>[
                        Image.asset('assets/images/junto-mobile__logo.png',
                            height: 22.0, width: 22.0),
                        const SizedBox(width: 7.5),
                        Text(
                          appbarTitle,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => GlobalSearch(),
                          ),
                        );
                      },
                      child: Container(
                        width: 42,
                        color: Colors.transparent,
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(Icons.search,
                            size: 22, color: Theme.of(context).primaryColor),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        NotificationScreen.route(),
                      ),
                      child: Container(
                        width: 42,
                        color: Colors.transparent,
                        alignment: Alignment.bottomRight,
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(CustomIcons.moon,
                            size: 22, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          degrees == true ? _degreesOfSeparation(context) : const SizedBox(),
        ],
      ),
    );
  }

  // Creates a row of degrees of separation; displayed if on 'Junto' perspective
  Widget _degreesOfSeparation(
    BuildContext context,
  ) {
    return Container(
      height: 50,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: .75,
            ),
          ),
          color: Theme.of(context).backgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _degree(
                  context: context,
                  degreeName: 'oo',
                  currentDegree: currentDegree,
                  degreeNumber: -1),
              _degree(
                  context: context,
                  degreeName: 'i',
                  currentDegree: currentDegree,
                  degreeNumber: 0),
              _degree(
                  context: context,
                  degreeName: 'ii',
                  currentDegree: currentDegree,
                  degreeNumber: 1),
              _degree(
                  context: context,
                  degreeName: 'iii',
                  currentDegree: currentDegree,
                  degreeNumber: 2),
              _degree(
                  context: context,
                  degreeName: 'iv',
                  currentDegree: currentDegree,
                  degreeNumber: 3),
              _degree(
                  context: context,
                  degreeName: 'v',
                  currentDegree: currentDegree,
                  degreeNumber: 4),
              _degree(
                  context: context,
                  degreeName: 'vi',
                  currentDegree: currentDegree,
                  degreeNumber: 5),
            ],
          ),
        ],
      ),
    );
  }

  // Function to return a single degree of separation; used in the _degreesOfSeparation
  // function above
  Widget _degree(
      {BuildContext context,
      String degreeName,
      int degreeNumber,
      String currentDegree}) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          switchDegree(degreeName: degreeName, degreeNumber: degreeNumber);
        },
        child: Container(
          alignment: Alignment.center,
          height: 49.25,
          color: Colors.transparent,
          child: Text(
            degreeName,
            style: degreeName == currentDegree
                ? TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w700)
                : TextStyle(color: Theme.of(context).primaryColorLight),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => expandedHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
