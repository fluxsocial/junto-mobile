import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/on_perspectives_changed.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/perspective_item.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/perspectives_appbar.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/perspectves_list.dart';

import 'package:feature_discovery/feature_discovery.dart';

class JuntoPerspectives extends StatelessWidget {
  const JuntoPerspectives({this.collectiveViewNav});
  final Function collectiveViewNav;

  @override
  Widget build(BuildContext context) {
    final juntoPerspective = PerspectiveModel(
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
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.height * .1 + 50,
          ),
          child: PerspectivesAppBar(collectiveViewNav: collectiveViewNav),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          margin: const EdgeInsets.only(bottom: 75),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: PageView(
                    physics: NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      ListView(
                        padding: const EdgeInsets.all(0),
                        children: <Widget>[
                          PerspectiveItem(
                            perspective: juntoPerspective,
                            onTap: () {
                              collectiveViewNav();
                              onPerspectivesChanged(
                                juntoPerspective,
                                context,
                              );
                            },
                          ),
                          PerspectivesList(
                            collectiveViewNav: collectiveViewNav,
                          ),
                        ],
                      ),
                      // Placeholder for future page views
                    ],
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
