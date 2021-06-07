import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective_populated_list.dart';
import 'package:junto_beta_mobile/screens/relationships/error_widget.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/filter_column_row.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/widgets/custom_refresh/collective_feed_refresh.dart';
import 'package:junto_beta_mobile/widgets/fetch_more.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CircleOpenExpressions extends StatefulWidget {
  CircleOpenExpressions();

  @override
  _CircleOpenExpressionsState createState() => _CircleOpenExpressionsState();
}

class _CircleOpenExpressionsState extends State<CircleOpenExpressions> {
  void _removeExpression(ExpressionResponse expression) {
    final bloc = context.read<CollectiveBloc>();
    bloc.add(DeleteCollective(expression.address));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppRepo>(builder: (context, AppRepo appRepo, _) {
      return BlocBuilder<CollectiveBloc, CollectiveState>(
        builder: (context, state) {
          final canFetch = state is CollectivePopulated &&
              (state.availableMore && !state.loadingMore);

          if (state is CollectiveError) {
            return JuntoErrorWidget(
              errorMessage: 'Hmm, something went wrong',
            );
          } else if (state is CollectivePopulated) {
            return CollectiveFeedRefresh(
              child: CustomScrollView(
                shrinkWrap: true,
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: FilterColumnRow(
                      twoColumnView:
                          Provider.of<AppRepo>(context, listen: false)
                              .twoColumnLayout,
                    ),
                  ),
                  // Empty SliverToBoxAdaptor is necessary, otherwise switching
                  //  between single and two column layouts creates an issue.
                  const SliverToBoxAdapter(),
                  if (state is CollectivePopulated)
                    CollectivePopulatedList(
                      state,
                      deleteExpression: _removeExpression,
                    ),
                  if (state is CollectivePopulated && state.loadingMore == true)
                    JuntoProgressIndicator(),
                  if (state is CollectiveLoading) JuntoProgressIndicator(),
                  if (canFetch)
                    // pagination
                    SliverToBoxAdapter(
                      child: FetchMoreButton(
                        onPressed: () {
                          context.read<CollectiveBloc>().add(
                                FetchMoreCollective(),
                              );
                        },
                      ),
                    ),
                ],
              ),
            );
          }

          return Container(
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.center,
            child: Transform.translate(
              offset: Offset(0.0, -50),
              child: JuntoProgressIndicator(),
            ),
          );
        },
      );
    });
  }
}
