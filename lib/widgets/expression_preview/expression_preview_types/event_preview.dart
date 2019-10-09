import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/palette.dart';

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
                  child: Image.asset(expression.expressionData.photo,
                      fit: BoxFit.fitWidth),
                )
              : const SizedBox(),
          Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  expression.expressionData.startTime,
                  style: const TextStyle(
                      color: JuntoPalette.juntoGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2.5),
                Text(
                  expression.expressionData.title,
                  style: TextStyle(
                      color: JuntoPalette.juntoGrey,
                      fontSize: 17,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2.5),
                Text(
                  expression.expressionData.location,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: JuntoPalette.juntoGrey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
