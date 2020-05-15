import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/single_column_preview/single_column_expression_preview.dart';

/// Box implementation of the custom `ListView` used across Junto.
class SingleColumnListView extends StatelessWidget {
  const SingleColumnListView({
    Key key,
    @required this.data,
    @required this.privacyLayer,
    @required this.itemCount,
    this.scrollChanged,
  }) : super(key: key);

  final List<ExpressionResponse> data;
  final String privacyLayer;
  final int itemCount;
  final ValueChanged<ScrollNotification> scrollChanged;

  bool _onScrollNotification(ScrollNotification scrollNotification) {
    final metrics = scrollNotification.metrics;
    double scrollPercent = (metrics.pixels / metrics.maxScrollExtent) * 100;
    if (scrollPercent.roundToDouble() == 60.0) {
      scrollChanged(scrollNotification);
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: _onScrollNotification,
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: ListView.builder(
          itemCount: itemCount,
          cacheExtent: MediaQuery.of(context).size.longestSide * 1.5,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.all(0),
          itemBuilder: (BuildContext context, int index) {
            return SingleColumnExpressionPreview(
              key: ValueKey<String>(data[index].address),
              expression: data[index],
            );
          },
        ),
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
  }) : super(key: key);

  final List<ExpressionResponse> data;
  final String privacyLayer;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          if (data[index].privacy == privacyLayer) {
            return SingleColumnExpressionPreview(
              key: ValueKey<String>(data[index].address),
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
