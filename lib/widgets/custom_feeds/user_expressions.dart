import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/app_config.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/backend/user_data_provider.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/screens/den/bloc/den_bloc.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/filter_column_row.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/single_listview.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/feed_placeholder.dart';
import 'package:junto_beta_mobile/widgets/custom_refresh/custom_refresh.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/fetch_more.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';

/// Linear list of expressions created by the given [userProfile].
class UserExpressions extends StatefulWidget {
  const UserExpressions({
    Key key,
    @required this.userProfile,
    @required this.privacy,
  }) : super(key: key);

  /// [UserProfile] of the user
  final UserProfile userProfile;

  /// Either Public or Private;
  final String privacy;

  @override
  _UserExpressionsState createState() => _UserExpressionsState();
}

class _UserExpressionsState extends State<UserExpressions> {
  Future<void> _switchColumnView(ExpressionFeedLayout columnType) async {
    await Provider.of<UserDataProvider>(context, listen: false)
        .switchColumnLayout(columnType);
  }

  void deleteDenExpression(ExpressionResponse expression) {
    context.bloc<DenBloc>().add(DeleteDenExpression(expression.address));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DenBloc, DenState>(
      builder: (BuildContext context, DenState state) {
        if (state is DenLoadingState) {
          return JuntoProgressIndicator();
        }
        if (state is DenLoadedState) {
          final results = state.expressions;
          return CustomRefresh(
            refresh: () async {
              await context.bloc<DenBloc>().add(RefreshDen());
            },
            child: Container(
              color: Theme.of(context).colorScheme.background,
              child: CustomScrollView(
                slivers: <Widget>[
                  Consumer<UserDataProvider>(builder:
                      (BuildContext context, UserDataProvider data, _) {
                    return SliverToBoxAdapter(
                      child: FilterColumnRow(
                        twoColumnView:
                            Provider.of<AppRepo>(context, listen: false)
                                .twoColumnLayout,
                        switchColumnView: _switchColumnView,
                      ),
                    );
                  }),
                  Consumer<UserDataProvider>(
                    builder: (BuildContext context, UserDataProvider data, _) {
                      if (Provider.of<AppRepo>(context, listen: false)
                          .twoColumnLayout) {
                        return TwoColumnList(
                          data: results,
                          useSliver: true,
                          deleteExpression: deleteDenExpression,
                        );
                      }
                      return SingleColumnSliverListView(
                        data: results,
                        privacyLayer: widget.privacy,
                        deleteExpression: deleteDenExpression,
                      );
                    },
                  ),
                  if (appConfig.flavor == Flavor.dev && results.length > 50)
                    SliverToBoxAdapter(
                      child: FetchMoreButton(
                        onPressed: () {
                          context.bloc<DenBloc>().add(
                                LoadMoreDen(),
                              );
                        },
                      ),
                    )
                ],
              ),
            ),
          );
        }
        if (state is DenEmptyState) {
          return FeedPlaceholder(
            placeholderText: 'No expressions yet. Feel free to start creating!',
          );
        }
        if (state is DenErrorState) {
          return JuntoErrorWidget(
            errorMessage: state.message,
          );
        }
        return SizedBox();
      },
    );
  }
}
