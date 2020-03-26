import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';

class ExpressionScrollRefresh extends StatefulWidget {
  ExpressionScrollRefresh({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  _ExpressionScrollRefreshState createState() =>
      _ExpressionScrollRefreshState();
}

class _ExpressionScrollRefreshState extends State<ExpressionScrollRefresh> {
  Completer<void> refreshCompleter;

  @override
  void initState() {
    super.initState();
    refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: _onScrollNotification,
      child: RefreshIndicator(
        onRefresh: () {
          context.bloc<CollectiveBloc>().add(RefreshCollective());
          return refreshCompleter.future;
        },
        displacement: MediaQuery.of(context).size.height / 4,
        child: BlocListener<CollectiveBloc, CollectiveState>(
          listener: _blocListener,
          child: widget.child,
        ),
      ),
    );
  }

  void _blocListener(BuildContext context, CollectiveState state) {
    if (state is CollectivePopulated &&
        refreshCompleter?.isCompleted == false) {
      refreshCompleter?.complete();
      refreshCompleter = Completer();
    }
    if (state is CollectiveError) {
      refreshCompleter?.completeError('Error during fetching');
    }
  }

  bool _onScrollNotification(ScrollNotification scrollNotification) {
    final metrics = scrollNotification.metrics;
    double scrollPercent = (metrics.pixels / metrics.maxScrollExtent) * 100;
    if (scrollPercent.roundToDouble() == 60.0) {
      BlocProvider.of<CollectiveBloc>(context).add(FetchMoreCollective());
      return true;
    }
    return false;
  }
}
