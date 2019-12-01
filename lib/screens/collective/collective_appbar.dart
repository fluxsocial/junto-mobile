import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives'
    '/create_perspective/create_perspective.dart' show SelectedUsers;
import 'package:junto_beta_mobile/widgets/previews/member_preview/member_preview.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/appbar/appbar_search.dart';

// Junto app bar used throughout the main screens. Rendered in JuntoTemplate.
class CollectiveAppBar extends SliverPersistentHeaderDelegate {
  CollectiveAppBar(
      {@required this.expandedHeight,
      this.newappbartitle,
      this.openPerspectivesDrawer});

  final double expandedHeight;
  final String newappbartitle;
  final Function openPerspectivesDrawer;
  var _users;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      height: 85,
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
                    newappbartitle,
                    style: Theme.of(context).appBarTheme.textTheme.body1,
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      // return Container(
                      //   height: MediaQuery.of(context).size.height * .9,
                      //   padding: const EdgeInsets.all(10),
                      //   decoration: BoxDecoration(
                      //     color: Theme.of(context).colorScheme.background,
                      //     borderRadius: const BorderRadius.only(
                      //       topLeft: Radius.circular(10),
                      //       topRight: Radius.circular(10),
                      //     ),
                      //   ),
                      // );
                      return ListenableProvider<
                          ValueNotifier<SelectedUsers>>.value(
                        value: _users,
                        child: JuntoAppbarSearch(),
                      );
                    },
                  );
                },
                child: Container(
                  width: 42,
                  padding: const EdgeInsets.only(right: 10),
                  alignment: Alignment.bottomRight,
                  color: Colors.transparent,
                  child: Icon(Icons.search,
                      size: 22, color: Theme.of(context).primaryColor),
                ),
              ),
              GestureDetector(
                onTap: () {},
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
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
