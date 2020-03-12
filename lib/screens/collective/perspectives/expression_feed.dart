import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/appbar/collective_appbar.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';

/// Homepage feed containing a List of expression for the given perspective.
/// The following parameters must be supplied:
///  - [refreshData]
///  - [expressionCompleter]
///  - [collectiveController]
///  - [appbarTitle]
///  - [userAddress]
class ExpressionFeed extends StatefulWidget {
  const ExpressionFeed({
    Key key,
    @required this.refreshData,
    @required this.expressionCompleter,
    @required this.collectiveController,
    @required this.appbarTitle,
    @required this.userAddress,
  })  : assert(refreshData != null),
        assert(expressionCompleter != null),
        assert(collectiveController != null),
        assert(appbarTitle != null),
        super(key: key);
  final VoidCallback refreshData;
  final ValueNotifier<Future<QueryResults<ExpressionResponse>>>
      expressionCompleter;
  final ScrollController collectiveController;
  final ValueNotifier<String> appbarTitle;
  final String userAddress;

  @override
  _ExpressionFeedState createState() => _ExpressionFeedState();
}

class _ExpressionFeedState extends State<ExpressionFeed> {
  bool twoColumnView = false;

  /// Changes the list view from two column layout to single
  void _switchColumnView(String columnType) {
    setState(() {
      if (columnType == 'two') {
        twoColumnView = true;
      } else if (columnType == 'single') {
        twoColumnView = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.refreshData,
      child: ValueListenableBuilder<Future<QueryResults<ExpressionResponse>>>(
        valueListenable: widget.expressionCompleter,
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
                  controller: widget.collectiveController,
                  slivers: <Widget>[
                    ValueListenableBuilder<String>(
                      valueListenable: widget.appbarTitle,
                      builder: (
                        BuildContext context,
                        String value,
                        Widget child,
                      ) {
                        return SliverPersistentHeader(
                          delegate: CollectiveAppBar(
                            expandedHeight: 135,
                            appbarTitle: value,
                            twoColumnView: twoColumnView,
                            switchColumnView: _switchColumnView,
                          ),
                          pinned: false,
                          floating: true,
                        );
                      },
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(<Widget>[
                        AnimatedCrossFade(
                          crossFadeState: twoColumnView
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300),
                          firstCurve: Curves.easeInOut,
                          firstChild: TwoColumnSliverListView(
                            userAddress: widget.userAddress,
                            data: snapshot.data.results,
                          ),
                          secondChild: SingleColumnSliverListView(
                            userAddress: widget.userAddress,
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
