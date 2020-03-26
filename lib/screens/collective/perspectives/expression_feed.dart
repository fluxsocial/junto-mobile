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
/// The following parameters must be supplied:
///  - [collectiveController]
class ExpressionFeed extends StatelessWidget {
  const ExpressionFeed({
    Key key,
    @required this.collectiveController,
  })  : assert(collectiveController != null),
        super(key: key);
  final ScrollController collectiveController;

  @override
  Widget build(BuildContext context) {
    return ExpressionScrollRefresh(
      child: BlocBuilder<CollectiveBloc, CollectiveState>(
        builder: (BuildContext context, CollectiveState state) {
          if (state is CollectiveError) {
            //TODO(Nash): Add illustration for error state.
            return CollectiveErrorLabel();
          }
          return CustomScrollView(
            controller: collectiveController,
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
