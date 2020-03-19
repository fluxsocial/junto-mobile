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
  Completer<void> refreshCompleter;

  // Fetches more expressions when the user scrolls past 60% of the existing list
  bool _onScrollNotification(ScrollNotification scrollNotification) {
    final metrics = scrollNotification.metrics;
    double scrollPercent = (metrics.pixels / metrics.maxScrollExtent) * 100;
    if (scrollPercent.roundToDouble() == 60.0) {
      BlocProvider.of<CollectiveBloc>(context).add(FetchMoreCollective());
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectiveBloc, CollectiveState>(
      builder: (BuildContext context, CollectiveState state) {
        if (state is CollectiveError) {
          //TODO(Nash): Add illustration for error state.
          return CollectiveErrorLabel();
        }
        return RefreshIndicator(
          onRefresh: () {
            refreshCompleter = Completer();
            context.bloc<CollectiveBloc>().add(RefreshCollective());
            return refreshCompleter.future;
          },
          child: BlocListener<CollectiveBloc, CollectiveState>(
            listener: _blocListener,
            child: NotificationListener(
              onNotification: _onScrollNotification,
              child: CustomScrollView(
                controller: widget.collectiveController,
                slivers: <Widget>[
                  AppBarWrapper(
                    title: widget.appbarTitle.value,
                  ),
                  if (state is CollectivePopulated)
                    CollectivePopulatedList(state),
                  if (state is CollectivePopulated && state.loadingMore == true)
                    const ExpressionProgressIndicator(),
                  if (state is CollectiveLoading)
                    const ExpressionProgressIndicator(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _blocListener(BuildContext context, CollectiveState state) {
    if (state is CollectivePopulated) {
      refreshCompleter?.complete();
    }
    if (state is CollectiveError) {
      refreshCompleter?.completeError('Error during fetching');
    }
  }
}

class CollectivePopulatedList extends StatelessWidget {
  const CollectivePopulatedList(
    this.state, {
    Key key,
  }) : super(key: key);

  final CollectivePopulated state;

  @override
  Widget build(BuildContext context) {
    if (state.results.length == 0) {
      return SliverToBoxAdapter(
        //TODO(Nash): Add illustration for error state.
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Center(
            child: Text('No expressions'),
          ),
        ),
      );
    } else {
      return SliverList(
        delegate: SliverChildListDelegate(
          <Widget>[
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 1000),
              curve: Curves.ease,
              tween: Tween<double>(begin: 0.0, end: 1.0),
              builder: (context, anim, child) {
                return Opacity(
                  opacity: anim,
                  child: child,
                );
              },
              child: Consumer<UserDataProvider>(
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
              ),
            ),
            const GetMoreExpressionsButton(),
          ],
        ),
      );
    }
  }
}

class CollectiveErrorLabel extends StatelessWidget {
  const CollectiveErrorLabel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FlatButton(
        child: Text('hmm, something is up with our servers'),
        onPressed: () =>
            context.bloc<CollectiveBloc>().add(RefreshCollective()),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 100.0),
      child: FlatButton(
        onPressed: () =>
            BlocProvider.of<CollectiveBloc>(context).add(FetchMoreCollective()),
        child: const Text('Get more'),
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
