import 'dart:async';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/appbar/collective_appbar.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Homepage feed containing a List of expression for the given perspective.
/// The following parameters must be supplied:
///  - [refreshData]
///  - [expressionCompleter]
///  - [collectiveController]
///  - [appbarTitle]
class ExpressionFeed extends StatefulWidget {
  const ExpressionFeed({
    Key key,
    @required this.refreshData,
    @required this.expressionCompleter,
    @required this.collectiveController,
    @required this.appbarTitle,
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

  @override
  _ExpressionFeedState createState() => _ExpressionFeedState();
}

class _ExpressionFeedState extends State<ExpressionFeed> {
  String _userAddress;
  AppRepo appState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appState = Provider.of<AppRepo>(context);
  }

  /// Changes the list view from two column layout to single
  Future<void> _switchColumnView(String columnType) async {
    if (columnType == 'two') {
      appState.setLayout(true);
    } else if (columnType == 'single') {
      appState.setLayout(false);
    }
    setState(() {});
    return;
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _userAddress = prefs.getString('user_id');
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInformation();
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
                            twoColumnView: appState.twoColumnLayout,
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
                          crossFadeState: appState.twoColumnLayout
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 300),
                          firstCurve: Curves.easeInOut,
                          firstChild: TwoColumnSliverListView(
                            userAddress: _userAddress,
                            data: snapshot.data.results,
                          ),
                          secondChild: SingleColumnSliverListView(
                            userAddress: _userAddress,
                            data: snapshot.data.results,
                            privacyLayer: 'Public',
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
