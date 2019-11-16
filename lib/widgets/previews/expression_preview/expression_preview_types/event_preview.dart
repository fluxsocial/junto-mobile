import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
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
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .3,
                    child: Image.asset(
                      expression.expressionData.photo,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : const SizedBox(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(expression.expressionData.title,
                    style: Theme.of(context).textTheme.title),
                const SizedBox(height: 2.5),
                Text(
                  expression.expressionData.location,
                  style: Theme.of(context).textTheme.body2,
                ),
                const SizedBox(height: 2.5),
                Text(
                  expression.expressionData.startTime,
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

// Text(
//   expression.expressionData.startTime,
//   style: Theme.of(context).textTheme.body2,
// ),
// const SizedBox(height: 2.5),
