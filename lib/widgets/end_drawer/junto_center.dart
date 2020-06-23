import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/junto_center/junto_center_appbar.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/junto_center/junto_center_fab.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/single_column_preview/single_column_expression_preview.dart';
import 'package:provider/provider.dart';

class JuntoCommunityCenter extends StatelessWidget {
  final List<String> _tabs = ['FEEDBACK', 'UPDATES'];
  final String communityCenterAddress = '48b97134-1a4d-deb0-b27c-9bcdfc33f386';

  @override
  Widget build(BuildContext context) {
    return FeatureDiscovery(
      child: Scaffold(
        floatingActionButton: SafeArea(
          child: JuntoCommunityCenterFab(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: FeatureDiscovery(
          child: DefaultTabController(
            length: _tabs.length,
            child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool boxIsScrolled) {
                return <Widget>[
                  SliverPersistentHeader(
                    delegate: JuntoCommunityCenterAppbar(
                      expandedHeight:
                          MediaQuery.of(context).size.height * .11 + 50,
                      tabs: _tabs,
                    ),
                    floating: true,
                    pinned: false,
                  ),
                ];
              },
              body: TabBarView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FutureBuilder<QueryResults<ExpressionResponse>>(
                        future:
                            Provider.of<ExpressionRepo>(context, listen: false)
                                .getCollectiveExpressions(
                          {
                            'context': '48b97134-1a4d-deb0-b27c-9bcdfc33f386',
                            'context_type': 'Group',
                            'pagination_position': '0',
                          },
                        ),
                        builder: (BuildContext context,
                            AsyncSnapshot<QueryResults<ExpressionResponse>>
                                snapshot) {
                          if (snapshot.hasData) {
                            print(snapshot.data);
                            return Expanded(
                              child: ListView(
                                padding: const EdgeInsets.all(0),
                                children: snapshot.data.results
                                    .map(
                                      (dynamic expression) =>
                                          SingleColumnExpressionPreview(
                                        expression: expression,
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                            return Center(
                              child: Text('Hmm, something went wrong'),
                            );
                          }
                          return Center(
                            child: Text('Hi'),
                          );
                        },
                      ),
                    ],
                  ),
                  SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
