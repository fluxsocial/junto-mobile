import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/on_perspectives_changed.dart';
import 'package:junto_beta_mobile/screens/collective/collective_fab.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/perspective_item.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/perspectives_header.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/perspectves_list.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:feature_discovery/feature_discovery.dart';

class JuntoPerspectives extends StatelessWidget {
  const JuntoPerspectives();

  @override
  Widget build(BuildContext context) {
    const juntoPerspective = const PerspectiveModel(
      address: null,
      name: 'JUNTO',
      about: null,
      creator: null,
      createdAt: null,
      isDefault: true,
      userCount: null,
      users: null,
    );
    return FeatureDiscovery(
      child: Scaffold(
        body: JuntoFilterDrawer(
          leftDrawer: null,
          rightMenu: JuntoDrawer(),
          scaffold: Scaffold(
            floatingActionButton: CollectiveActionButton(
              isVisible: ValueNotifier(true),
              actionsVisible: true,
              onTap: () {
                Navigator.maybePop(context);
              },
              onUpTap: () {},
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: PerspectivesAppbar(),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(0),
                      children: <Widget>[
                        PerspectiveItem(
                          perspective: juntoPerspective,
                          onTap: () => onPerspectivesChanged(
                            juntoPerspective,
                            context,
                          ),
                        ),
                        PerspectivesList(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
