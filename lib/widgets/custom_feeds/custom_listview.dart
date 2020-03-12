import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/single_column_preview/single_column_expression_preview.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/two_column_preview/two_column_expression_preview.dart';

/// Box implementation of the custom `ListView` used across Junto.
class TwoColumnListView extends StatelessWidget {
  const TwoColumnListView({
    Key key,
    @required this.data,
    @required this.userAddress,
    @required this.privacyLayer,
    @required this.showComments,
  }) : super(key: key);

  final List<ExpressionResponse> data;
  final String userAddress;
  final String privacyLayer;
  final bool showComments;

  @override
  Widget build(BuildContext context) {
    return ListView(
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
                        userAddress: userAddress,
                        allowComments: showComments,
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
                        userAddress: userAddress,
                        allowComments: showComments,
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
    @required this.userAddress,
  }) : super(key: key);

  final List<ExpressionResponse> data;
  final String userAddress;

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
                      userAddress: userAddress,
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
                      userAddress: userAddress,
                    )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Box implementation of the custom `ListView` used across Junto.
class SingleColumnListView extends StatelessWidget {
  const SingleColumnListView({
    Key key,
    @required this.data,
    @required this.userAddress,
    @required this.privacyLayer,
    @required this.showComments,
  }) : super(key: key);

  final List<ExpressionResponse> data;
  final String userAddress;
  final String privacyLayer;
  final bool showComments;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                userAddress: userAddress,
              )
        ],
      ),
    );
  }
}

/// Sliver implementation of the custom `ListView` used across Junto.
class SingleColumnSliverListView extends StatelessWidget {
  const SingleColumnSliverListView(
      {Key key,
      @required this.data,
      @required this.userAddress,
      @required this.privacyLayer})
      : super(key: key);

  final List<ExpressionResponse> data;
  final String userAddress;
  final String privacyLayer;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                userAddress: userAddress,
              )
        ],
      ),
    );
  }
}
