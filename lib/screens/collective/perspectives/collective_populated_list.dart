import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/collective/bloc/collective_bloc.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/single_listview.dart';
import 'package:junto_beta_mobile/widgets/fetch_more.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/two_column_preview/two_column_expression_preview.dart';
import 'package:provider/provider.dart';

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
        child: const SizedBox(),
      );
    } else {
      return Consumer<UserDataProvider>(builder: (context, snapshot, _) {
        return SliverList(
          delegate: SliverChildListDelegate(
            <Widget>[
              AnimatedSwitcher(
                duration: kThemeChangeDuration,
                child: snapshot.twoColumnView
                    ? _TwoColumnList(data: state.results)
                    : SingleColumnSliverListView(
                        key: ValueKey<String>('single-column'),
                        data: state.results,
                        privacyLayer: 'Public',
                      ),
              ),
              if (state.availableMore == true && state.loadingMore != true)
                FetchMoreButton(
                  onPressed: () => context.bloc<CollectiveBloc>().add(
                        FetchMoreCollective(),
                      ),
                ),
            ],
          ),
        );
      });
    }
  }
}

class _TwoColumnList extends StatelessWidget {
  const _TwoColumnList({Key key, @required this.data}) : super(key: key);
  final List<ExpressionResponse> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: MediaQuery.of(context).size.height,
      child: StaggeredGridView.countBuilder(
        key: ValueKey<String>('two-column'),
        crossAxisCount: 4,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 4.0,
        staggeredTileBuilder: (index) {
          return StaggeredTile.fit(2);
        },
        itemBuilder: (context, index) {
          return TwoColumnExpressionPreview(
            key: ValueKey<String>(data[index].address),
            expression: data[index],
          );
        },
        itemCount: data.length,
      ),
    );
  }
}
