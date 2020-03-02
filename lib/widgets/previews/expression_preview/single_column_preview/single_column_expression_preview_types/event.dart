import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';

/// Shows a preview for the given event.
/// Widget takes [eventTitle], [eventLocation] and [eventPhoto]
class EventPreview extends StatelessWidget {
  const EventPreview({Key key, @required this.expression}) : super(key: key);

  /// Name of the event
  final ExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          expression.expressionData.photo != ''
              ? ClipRRect(
                  child: Container(
                    child: CachedNetworkImage(
                        width: MediaQuery.of(context).size.width,
                        imageUrl: expression.expressionData.photo,
                        placeholder: (BuildContext context, String _) {
                          return Container(
                            color: Theme.of(context).dividerColor,
                          );
                        },
                        fit: BoxFit.cover),
                  ),
                )
              : const SizedBox(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(expression.expressionData.title,
                    style: Theme.of(context).textTheme.headline6),
                const SizedBox(height: 2.5),
                Text(
                  expression.expressionData.location,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
