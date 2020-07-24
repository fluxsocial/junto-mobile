import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/single_column_preview/single_column_expression_preview.dart';

/// Box implementation of the custom `ListView` used across Junto.
class SingleColumnListView extends StatelessWidget {
  const SingleColumnListView({
    Key key,
    @required this.data,
    @required this.privacyLayer,
    @required this.deleteExpression,
  }) : super(key: key);

  final List<ExpressionResponse> data;
  final String privacyLayer;
  final ValueChanged<ExpressionResponse> deleteExpression;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        padding: const EdgeInsets.all(0),
        children: <Widget>[
          for (int index = 0; index < data.length + 1; index++)
            if (index == data.length)
              const SizedBox()
            else if (data[index].privacy == privacyLayer)
              SingleColumnExpressionPreview(
                key: ValueKey<String>(data[index].address),
                expression: data[index],
                deleteExpression: deleteExpression,
              )
        ],
      ),
    );
  }
}

/// Sliver implementation of the custom `ListView` used across Junto.
class SingleColumnSliverListView extends StatelessWidget {
  const SingleColumnSliverListView({
    Key key,
    @required this.data,
    @required this.privacyLayer,
    @required this.deleteExpression,
  }) : super(key: key);

  final List<ExpressionResponse> data;
  final String privacyLayer;
  final ValueChanged<ExpressionResponse> deleteExpression;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (data[index].privacy == privacyLayer) {
            return SingleColumnExpressionPreview(
              key: ValueKey<String>(data[index].address),
              deleteExpression: deleteExpression,
              expression: data[index],
            );
          }
          return SizedBox();
        },
        childCount: data.length,
      ),
    );
  }
}
