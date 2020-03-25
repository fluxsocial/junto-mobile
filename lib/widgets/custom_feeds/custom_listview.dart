import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/single_column_preview/single_column_expression_preview.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/two_column_preview/two_column_expression_preview.dart';

/// Box implementation of the custom `ListView` used across Junto.
class TwoColumnListView extends StatelessWidget {
  const TwoColumnListView({
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
      if (scrollChanged != null) {
        scrollChanged(scrollNotification);
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: _onScrollNotification,
      child: ListView(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * .5,
                padding: const EdgeInsets.only(left: 10, right: 5, top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    for (int index = 0; index < data.length + 1; index++)
                      if (index == data.length)
                        const SizedBox()
                      else if (index.isEven &&
                          data[index].privacy == privacyLayer)
                        TwoColumnExpressionPreview(
                          expression: data[index],
                        )
                      else
                        const SizedBox()

                    // even number indexes
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * .5,
                padding: const EdgeInsets.only(left: 5, right: 10, top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // odd number indexes
                    for (int index = 0; index < data.length + 1; index++)
                      if (index == data.length)
                        const SizedBox()
                      else if (index.isOdd &&
                          data[index].privacy == privacyLayer)
                        TwoColumnExpressionPreview(
                          expression: data[index],
                        )
                      else
                        const SizedBox()
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

/// Sliver implementation of the custom `ListView` used across Junto.
class TwoColumnSliverListView extends StatelessWidget {
  const TwoColumnSliverListView({
    Key key,
    @required this.data,
    this.scrollChanged,
  }) : super(key: key);

  final List<ExpressionResponse> data;

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width * .5,
              padding: const EdgeInsets.only(
                top: 10,
                left: 10,
                right: 5,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  for (int index = 0; index < data.length + 1; index++)
                    if (index == data.length)
                      const SizedBox()
                    else if (index.isEven)
                      TwoColumnExpressionPreview(
                        key: ValueKey<String>(data[index].address),
                        expression: data[index],
                      )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * .5,
              padding: const EdgeInsets.only(
                top: 10,
                left: 5,
                right: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  for (int index = 0; index < data.length + 1; index++)
                    if (index == data.length)
                      const SizedBox()
                    else if (index.isOdd)
                      TwoColumnExpressionPreview(
                        key: ValueKey<String>(data[index].address),
                        expression: data[index],
                      )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
