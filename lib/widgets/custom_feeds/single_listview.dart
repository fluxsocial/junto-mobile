import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/single_column_preview/single_column_expression_preview.dart';

/// Box implementation of the custom `ListView` used across Junto.
class SingleColumnListView extends StatelessWidget {
  const SingleColumnListView({
    Key key,
    @required this.data,
    @required this.privacyLayer,
    this.scrollChanged,
  }) : super(key: key);

  final List<ExpressionResponse> data;
  final String privacyLayer;

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
        child: ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: <Widget>[
            for (int index = 0; index < data.length + 1; index++)
              if (index == data.length)
                const SizedBox()
              else if (data[index].privacy == privacyLayer)
                SingleColumnExpressionPreview(
                  key: ValueKey<String>(data[index].address),
                  expression: data[index],
                )
          ],
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
    @required this.scrollChanged,
  }) : super(key: key);

  final List<ExpressionResponse> data;
  final String privacyLayer;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            for (int index = 0; index < data.length + 1; index++)
              if (index == data.length)
                const SizedBox()
              else if (data[index].privacy == privacyLayer)
                SingleColumnExpressionPreview(
                  key: ValueKey<String>(data[index].address),
                  expression: data[index],
                )
          ],
        ),
      ),
    );
  }
}
