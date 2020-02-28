import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/expression_preview/expression_preview.dart';

class CustomListView extends StatelessWidget {
  const CustomListView({
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
                      ExpressionPreview(
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
                      ExpressionPreview(
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
