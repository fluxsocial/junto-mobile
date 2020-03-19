import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/user_data/user_data_provider.dart';
import 'package:junto_beta_mobile/widgets/appbar/collective_appbar.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

enum ExpressionFeedLayout { single, two }

/// Homepage feed containing a List of expression for the given perspective.
/// The following parameters must be supplied:
///  - [collectiveController]
///  - [appbarTitle]
class ExpressionFeed extends StatefulWidget {
  const ExpressionFeed({
    Key key,
    @required this.collectiveController,
    @required this.appbarTitle,
  })  : assert(collectiveController != null),
        assert(appbarTitle != null),
        super(key: key);
  final ScrollController collectiveController;
  final ValueNotifier<String> appbarTitle;

  @override
  _ExpressionFeedState createState() => _ExpressionFeedState();
}

class _ExpressionFeedState extends State<ExpressionFeed> {
  // Fetches more expressions when the user scrolls past 60% of the existing list
  bool _onScrollNotification(ScrollNotification scrollNotification) {
    final metrics = scrollNotification.metrics;
    double scrollPercent = (metrics.pixels / metrics.maxScrollExtent) * 100;
    if (scrollPercent.roundToDouble() == 60.0) {
      print('fetching');
      BlocProvider.of<CollectiveBloc>(context).add(FetchMoreCollective());
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        //TODO: add completer
        context.bloc<CollectiveBloc>().add(RefreshCollective());
        await Future.value(true);
      },
      child: BlocBuilder<CollectiveBloc, CollectiveState>(
        builder: (BuildContext context, CollectiveState state) {
          if (state is CollectiveError) {
            //TODO(Nash): Add illustration for empty state.
            return CollectiveErrorLabel();
          }
          return NotificationListener(
            onNotification: _onScrollNotification,
            child: CustomScrollView(
              controller: widget.collectiveController,
              slivers: <Widget>[
                AppBarWrapper(
                  title: widget.appbarTitle.value,
                ),
                if (state is CollectivePopulated)
                  SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        Consumer<UserDataProvider>(
                          builder: (context, user, _) => AnimatedCrossFade(
                            crossFadeState: user.twoColumnView
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            duration: const Duration(milliseconds: 300),
                            firstCurve: Curves.easeInOut,
                            firstChild: TwoColumnSliverListView(
                              data: state.results,
                            ),
                            secondChild: SingleColumnSliverListView(
                              data: state.results,
                              privacyLayer: 'Public',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                if (state is CollectivePopulated)
                  const GetMoreExpressionsButton(),
                if (state is CollectivePopulated && state.loadingMore == true)
                  const ExpressionProgressIndicator(),
                if (state is CollectiveLoading)
                  const ExpressionProgressIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class CollectiveErrorLabel extends StatelessWidget {
  const CollectiveErrorLabel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(child: Text('hmm, something is up with our servers')),
      ),
    );
  }
}

class GetMoreExpressionsButton extends StatelessWidget {
  const GetMoreExpressionsButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 100.0),
      sliver: SliverToBoxAdapter(
        child: FlatButton(
          onPressed: () => BlocProvider.of<CollectiveBloc>(context)
              .add(FetchMoreCollective()),
          child: const Text('Get more'),
        ),
      ),
    );
  }
}

class ExpressionProgressIndicator extends StatelessWidget {
  const ExpressionProgressIndicator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Center(
          child: JuntoProgressIndicator(),
        ),
      ),
    );
  }
}

class AppBarWrapper extends StatelessWidget {
  const AppBarWrapper({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      delegate: CollectiveAppBar(
        expandedHeight: 135,
        appbarTitle: title,
      ),
      pinned: false,
      floating: true,
    );
  }
}
