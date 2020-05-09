import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/models.dart';

class NotificationDynamicPreview extends StatelessWidget {
  const NotificationDynamicPreview({this.item});

  final JuntoNotification item;
  @override
  Widget build(BuildContext context) {
    final String title = item.sourceExpression.expressionData['title'];
    final String body = item.sourceExpression.expressionData['body'];

    return Container(
      width: MediaQuery.of(context).size.width - 68,
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 15.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          // show title of expression
          if (title.isNotEmpty)
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          // add space if title and body are both not empty
          if (title.isNotEmpty && body.isNotEmpty)
            const SizedBox(height: 10),
          // show body of expression
          if (body.isNotEmpty)
            Text(
              body,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            )
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(
          width: .75,
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
