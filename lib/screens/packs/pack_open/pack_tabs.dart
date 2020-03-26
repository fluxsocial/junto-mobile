import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_members.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/group_expressions.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';

class PackTabs extends StatelessWidget {
  const PackTabs({
    Key key,
    @required this.group,
  }) : super(key: key);

  final Group group;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: NotificationListener<OverscrollNotification>(
        onNotification: (value) {
          if (value.overscroll < 0 && value.metrics.axis == Axis.horizontal) {
            JuntoFilterDrawer.of(context).toggle();
            return true;
          } else if (value.overscroll > 0 &&
              value.metrics.axis == Axis.horizontal) {
            JuntoFilterDrawer.of(context).toggleRightMenu();
            return true;
          }
          return false;
        },
        child: TabBarView(
          children: <Widget>[
            GroupExpressions(
              key: const PageStorageKey<String>('public-pack'),
              group: group,
              privacy: 'Public',
            ),
            GroupExpressions(
              key: const PageStorageKey<String>('private-pack'),
              group: group,
              privacy: 'Private',
            ),
            PackOpenMembers(
              key: UniqueKey(),
              packAddress: group.address,
            )
          ],
        ),
      ),
    );
  }
}
