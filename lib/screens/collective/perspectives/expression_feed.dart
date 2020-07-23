import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/widgets/appbar/collective_appbar.dart';
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
    this.collectiveViewNav,
  }) : super(key: key);

  final Function collectiveViewNav;

  @override
  _ExpressionFeedState createState() => _ExpressionFeedState();
}

class _ExpressionFeedState extends State<ExpressionFeed> {
  void _removeExpression(ExpressionResponse expression) {
    final bloc = context.bloc<CollectiveBloc>();
    bloc.add(DeleteCollective(expression.address));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectiveBloc, CollectiveState>(
      builder: (BuildContext context, CollectiveState state) {
        final canFetch = state is CollectivePopulated && (state.availableMore && !state.loadingMore);
        if (state is CollectiveError) {
          return CollectiveErrorLabel();
        }
        return NestedScrollView(
          headerSliverBuilder: (context, innerBoxScrolled) => [
            // SliverPersistentHeader made into custom appbar with pinned
            // set to false and floating set to true
            SliverPersistentHeader(
              delegate: CollectiveAppBar(
                expandedHeight: MediaQuery.of(context).size.height * .1 + 50,
                appbarTitle:
                    state is CollectivePopulated ? state.name : 'JUNTO',
                collectiveViewNav: widget.collectiveViewNav,
              ),
              pinned: false,
              floating: true,
            ),
          ],
          body: CollectiveFeedRefresh(
            child: CustomScrollView(
              shrinkWrap: true,
              slivers: <Widget>[
                // Empty SliverToBoxAdaptor is necessary, otherwise switching
                //  between single and two column layouts creates an issue.
                const SliverToBoxAdapter(),
                if (state is CollectivePopulated)
                  CollectivePopulatedList(
                    state,
                    deleteExpression: _removeExpression,
                  ),
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
