import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/appbar_wrapper.dart';

import 'collective_error_label.dart';
import 'collective_populated_list.dart';
import 'expression_progress_indicator.dart';
import 'expression_scroll_refresh.dart';

enum ExpressionFeedLayout { single, two }

/// Homepage feed containing a List of expression for the given perspective.

class ExpressionFeed extends StatefulWidget {
  const ExpressionFeed({
    Key key,
  }) : super(key: key);

  @override
  _ExpressionFeedState createState() => _ExpressionFeedState();
}

class _ExpressionFeedState extends State<ExpressionFeed> {
  @override
  Widget build(BuildContext context) {
    return ExpressionScrollRefresh(
      child: BlocBuilder<CollectiveBloc, CollectiveState>(
        builder: (BuildContext context, CollectiveState state) {
          if (state is CollectiveError) {
            return CollectiveErrorLabel();
          }
          return CustomScrollView(
            slivers: <Widget>[
              AppBarWrapper(
                title: state is CollectivePopulated ? state.name : 'JUNTO',
              ),
              if (state is CollectivePopulated) CollectivePopulatedList(state),
              if (state is CollectivePopulated && state.loadingMore == true)
                const ExpressionProgressIndicator(),
              if (state is CollectiveLoading)
                const ExpressionProgressIndicator(),
            ],
          );
        },
      ),
    );
  }
}
