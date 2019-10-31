import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class JuntoDenAppbar extends StatelessWidget {
  const JuntoDenAppbar({
    Key key,
    @required this.handle,
    @required this.name,
    @required this.profilePicture,
    @required this.bio,
  }) : super(key: key);

  final String handle;
  final String name;
  final String profilePicture;
  final String bio;

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
        background: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * .24,
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              alignment: Alignment.bottomLeft,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: <double>[0.1, 0.9],
                  colors: <Color>[
                    JuntoPalette.juntoSecondary,
                    JuntoPalette.juntoPrimary,
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const SizedBox(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          // name,
                          'Eric Yang',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Scaffold.of(context).openEndDrawer();
                        },
                        child: Container(
                            margin: const EdgeInsets.only(left: 10),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 1.5),
                                borderRadius: BorderRadius.circular(5)),
                            child: Text(
                              'Edit Den',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            )),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      expandedHeight: MediaQuery.of(context).size.height * .24,
      forceElevated: false,
    );
  }
}

/// Custom [SliverPersistentHeaderDelegate] used on Den.
class JuntoAppBarDelegate extends SliverPersistentHeaderDelegate {
  JuntoAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height + .5;

  @override
  double get maxExtent => _tabBar.preferredSize.height + .5;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xffeeeeee), width: .5),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(JuntoAppBarDelegate oldDelegate) {
    return false;
  }
}
