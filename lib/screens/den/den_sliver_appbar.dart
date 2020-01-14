import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:provider/provider.dart';

class JuntoDenSliverAppbar extends StatelessWidget {
  const JuntoDenSliverAppbar({
    Key key,
    @required this.name,
    @required this.userAddress,
  }) : super(key: key);

  final String name;

  //FIXME(Nash): Remove
  final String userAddress;

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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: const <double>[0.2, 0.9],
                  colors: <Color>[
                    Theme.of(context).colorScheme.secondaryVariant,
                    Theme.of(context).accentColor,
                  ],
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  //FIXME(Nash): Remove this
                  Navigator.push(context, FollowersList.route(userAddress));
                },
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
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        border: Border(
          bottom: BorderSide(color: Theme.of(context).dividerColor, width: .5),
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

class FollowersList extends StatefulWidget {
  const FollowersList({Key key, this.userAddress}) : super(key: key);

  static Route<dynamic> route(String userAddress) {
    return MaterialPageRoute<dynamic>(builder: (BuildContext context) {
      return FollowersList(
        userAddress: userAddress,
      );
    });
  }

  final String userAddress;

  @override
  _FollowersListState createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: FutureBuilder<List<UserProfile>>(
          future: Provider.of<UserRepo>(context, listen: false)
              .getFollowers(widget.userAddress),
          builder: (
            BuildContext context,
            AsyncSnapshot<List<UserProfile>> snapshot,
          ) {
            return Container();
          },
        ),
      ),
    );
  }
}
