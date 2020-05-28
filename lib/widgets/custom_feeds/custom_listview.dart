import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/two_column_preview/two_column_expression_preview.dart';

/// Box implementation of the custom `ListView` used across Junto.
class TwoColumnListView extends StatelessWidget {
  const TwoColumnListView({
    Key key,
    @required this.data,
    @required this.privacyLayer,
  }) : super(key: key);

  final List<ExpressionResponse> data;
  final String privacyLayer;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: const EdgeInsets.all(0),
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
                    else if (index.isOdd && data[index].privacy == privacyLayer)
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
    );
  }
}

/// Sliver implementation of the custom `ListView` used across Junto.
class TwoColumnSliverListView extends StatelessWidget {
  const TwoColumnSliverListView({
    Key key,
    @required this.data,
  }) : super(key: key);

  final List<ExpressionResponse> data;

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
