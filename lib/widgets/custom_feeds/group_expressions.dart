import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/app_config.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/expression_feed.dart';
import 'package:junto_beta_mobile/screens/packs/packs_bloc/pack_bloc.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/custom_listview.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/filter_column_row.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/single_listview.dart';
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

  Future<void> _switchColumnView(String columnType) async {
    if (columnType == 'two') {
      Provider.of<UserDataProvider>(context, listen: false)
          .switchColumnLayout(ExpressionFeedLayout.two);
    } else {
      Provider.of<UserDataProvider>(context, listen: false)
          .switchColumnLayout(ExpressionFeedLayout.single);
    }
  }

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
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: FilterColumnRow(
                      twoColumnView: data.twoColumnView,
                      switchColumnView: _switchColumnView,
                    ),
                  ),
                  if (data.twoColumnView)
                    TwoColumnList(
                      data: _results,
                      useSliver: true,
                    ),
                  if (!data.twoColumnView)
                    SingleColumnSliverListView(
                      data: _results,
                      privacyLayer: widget.privacy,
                    ),
                  if (appConfig.flavor == Flavor.dev)
                    SliverToBoxAdapter(
                      child: FetchMoreButton(
                        onPressed: _fetchMore,
                      ),
                    )
                ],
              );
            },
          );
        }
        if (state is PacksEmpty) {
          //TODO(Eric): Handle empty state
          return Container();
        }
        if (state is PacksError) {
          return JuntoErrorWidget(errorMessage: state.message ?? '');
        }
        return JuntoLoader();
      },
    );
  }
}
