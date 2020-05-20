import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/appbar_wrapper.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/collective_populated_list.dart';
import 'package:junto_beta_mobile/widgets/custom_refresh/collective_feed_refresh.dart';
import 'package:junto_beta_mobile/widgets/fetch_more.dart';

import 'collective_error_label.dart';
import 'expression_progress_indicator.dart';

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
    return BlocBuilder<CollectiveBloc, CollectiveState>(
      builder: (BuildContext context, CollectiveState state) {
        final canFetch = state is CollectivePopulated &&
            (state.availableMore == true && state.loadingMore != true);
        if (state is CollectiveError) {
          return CollectiveErrorLabel();
        }
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            // SliverPersistentHeader made into custom appbar with pinned
            // set to false and floating set to true
            AppBarWrapper(
              title: state is CollectivePopulated ? state.name : 'JUNTO',
            ),
          ],
          body: CollectiveFeedRefresh(
            child: CustomScrollView(
              slivers: <Widget>[
                // Empty SliverToBoxAdaptor is necessary, otherwise switching
                //  between single and two column layouts creates an issue.
                const SliverToBoxAdapter(),
                if (state is CollectivePopulated)
                  // Collective Feed (either single or two column layout)
                  CollectivePopulatedList(state),
                if (state is CollectivePopulated && state.loadingMore == true)
                  const ExpressionProgressIndicator(),
                if (state is CollectiveLoading)
                  const ExpressionProgressIndicator(),
                if (canFetch)
                  // pagination
                  SliverToBoxAdapter(
                    child: FetchMoreButton(
                      onPressed: () {
                        context.bloc<CollectiveBloc>().add(
                              FetchMoreCollective(),
                            );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
