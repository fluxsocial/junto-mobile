import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';

/// Shows a preview for the given event.
/// Widget takes [eventTitle], [eventLocation] and [eventPhoto]
class EventPreview extends StatelessWidget {
  const EventPreview({Key key, @required this.expression}) : super(key: key);

  /// Name of the event
  final CentralizedExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          expression.expressionData.photo != ''
              ? Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(
                    expression.expressionData.photo,
                    fit: BoxFit.fitWidth,
                  ),
                )
              : const SizedBox(),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  expression.expressionData.startTime,
                  style: Theme.of(context).textTheme.body2,
                ),
                const SizedBox(height: 2.5),
                Text(expression.expressionData.title,
                    style: Theme.of(context).textTheme.title),
                const SizedBox(height: 2.5),
                Text(
                  expression.expressionData.location,
                  style: Theme.of(context).textTheme.body2,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
