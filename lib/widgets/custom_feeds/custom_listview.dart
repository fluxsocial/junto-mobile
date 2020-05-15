import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/two_column_preview/two_column_expression_preview.dart';

class TwoColumnList extends StatelessWidget {
  const TwoColumnList({
    Key key,
    @required this.data,
    this.useSliver = false,
  }) : super(key: key);

  final List<ExpressionResponse> data;
  final bool useSliver;

  @override
  Widget build(BuildContext context) {
    if (useSliver) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        sliver: SliverStaggeredGrid.countBuilder(
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      height: MediaQuery.of(context).size.height,
      child: StaggeredGridView.countBuilder(
        key: ValueKey<String>('two-column'),
        addAutomaticKeepAlives: true,
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
