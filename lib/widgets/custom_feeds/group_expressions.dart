import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/app_config.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories/app_repo.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/packs/packs_bloc/pack_bloc.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/filter_column_row.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/single_listview.dart';
import 'package:junto_beta_mobile/widgets/placeholders/feed_placeholder.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer_relationships/error_widget.dart';
import 'package:junto_beta_mobile/widgets/fetch_more.dart';
import 'package:provider/provider.dart';

/// Linear list of expressions created by the given [userProfile].
class GroupExpressions extends StatefulWidget {
  const GroupExpressions({
    Key key,
    @required this.group,
    @required this.privacy,
  }) : super(key: key);

  /// Group
  final Group group;
  final String privacy;

  @override
  _GroupExpressionsState createState() => _GroupExpressionsState();
}

class _GroupExpressionsState extends State<GroupExpressions> {
  bool get isPrivate => widget.privacy != 'Public';

  void _fetchMore() {
    context.bloc<PackBloc>().add(FetchMorePacks());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PackBloc, PackState>(
      builder: (context, state) {
        if (state is PacksLoading) {
          return JuntoLoader();
        }
        if (state is PacksLoaded) {
          final _results = isPrivate
              ? state.privateExpressions.results
              : state.publicExpressions.results;
          return Consumer<UserDataProvider>(
            builder: (BuildContext context, UserDataProvider data, _) {
              if (_results.isEmpty) {
                return FeedPlaceholder(
                  placeholderText: 'No expressions yet!',
                  image: 'assets/images/junto-mobile__placeholder--feed.png',
                );
              } else {
                return CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: FilterColumnRow(
                        twoColumnView:
                            Provider.of<AppRepo>(context, listen: false)
                                .twoColumnLayout,
                      ),
                    ),
                    if (Provider.of<AppRepo>(context, listen: false)
                        .twoColumnLayout)
                      TwoColumnList(
                        data: _results,
                        useSliver: true,
                        deleteExpression: (expression) {
                          context.bloc<PackBloc>().add(
                                DeletePackExpression(expression.address),
                              );
                        },
                      ),
                    if (!Provider.of<AppRepo>(context, listen: false)
                            .twoColumnLayout ==
                        true)
                      SingleColumnSliverListView(
                        data: _results,
                        privacyLayer: widget.privacy,
                        deleteExpression: (expression) {
                          context.bloc<PackBloc>().add(
                                DeletePackExpression(expression.address),
                              );
                        },
                      ),
                    if (appConfig.flavor == Flavor.tst && _results.length > 50)
                      SliverToBoxAdapter(
                        child: FetchMoreButton(
                          onPressed: _fetchMore,
                        ),
                      )
                  ],
                );
              }
            },
          );
        }
        if (state is PacksEmpty) {
          return const SizedBox();
        }
        if (state is PacksError) {
          return JuntoErrorWidget(errorMessage: state.message ?? '');
        }
        return JuntoLoader();
      },
    );
  }
}
