import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/appbar/collective_appbar.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';

/// Homepage feed containing a List of expression for the given perspective.
/// The following parameters must be supplied:
///  - [refreshData]
///  - [expressionCompleter]
///  - [collectiveController]
///  - [appbarTitle]
///  - [toggleFilterDrawer]
///  - [twoColumnView]
///  - [switchColumnView]
///  - [userAddress]
class ExpressionFeed extends StatelessWidget {
  const ExpressionFeed({
    Key key,
    @required this.refreshData,
    @required this.expressionCompleter,
    @required this.collectiveController,
    @required this.appbarTitle,
    @required this.toggleFilterDrawer,
    @required this.twoColumnView,
    @required this.switchColumnView,
    @required this.userAddress,
  })  : assert(refreshData != null),
        assert(expressionCompleter != null),
        assert(collectiveController != null),
        assert(appbarTitle != null),
        assert(toggleFilterDrawer != null),
        assert(twoColumnView != null),
        assert(switchColumnView != null),
        super(key: key);
  final VoidCallback refreshData;
  final ValueNotifier<Future<QueryResults<ExpressionResponse>>>
      expressionCompleter;
  final ScrollController collectiveController;
  final String appbarTitle;
  final VoidCallback toggleFilterDrawer;
  final bool twoColumnView;
  final ValueChanged<String> switchColumnView;
  final String userAddress;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshData,
      child: ValueListenableBuilder<Future<QueryResults<ExpressionResponse>>>(
        valueListenable: expressionCompleter,
        builder: (
          BuildContext context,
          Future<QueryResults<ExpressionResponse>> value,
          _,
        ) {
          return FutureBuilder<QueryResults<ExpressionResponse>>(
            future: value,
            builder: (
              BuildContext context,
              AsyncSnapshot<QueryResults<ExpressionResponse>> snapshot,
            ) {
              if (snapshot.hasError) {
                //TODO(Nash): Add illustration for empty state.
                return const Center(
                  child: Text('hmm, something is up with our servers'),
                );
              }
              if (snapshot.hasData) {
                return CustomScrollView(
                  controller: collectiveController,
                  slivers: <Widget>[
                    SliverPersistentHeader(
                      delegate: CollectiveAppBar(
                        expandedHeight: 135,
                        appbarTitle: appbarTitle,
                        openFilterDrawer: toggleFilterDrawer,
                        twoColumnView: twoColumnView,
                        switchColumnView: switchColumnView,
                      ),
                      pinned: false,
                      floating: true,
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(<Widget>[
                        AnimatedCrossFade(
                          crossFadeState: twoColumnView
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300),
                          firstChild: TwoColumnSliverListView(
                            userAddress: userAddress,
                            data: snapshot.data.results,
                          ),
                          secondChild: SingleColumnSliverListView(
                            userAddress: userAddress,
                            data: snapshot.data.results,
                          ),
                        )
                      ]),
                    )
                  ],
                );
              }
              return Center(
                child: JuntoProgressIndicator(),
              );
            },
          );
        },
      ),
    );
  }
}
