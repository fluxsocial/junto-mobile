import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventOpen extends StatelessWidget {
  const EventOpen(this.expression);

  final CentralizedExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    final CentralizedEventFormExpression eventExpression =
        expression.expressionData as CentralizedEventFormExpression;
    final String eventTitle = eventExpression.title;
    final String eventStartTime = eventExpression.startTime;
    final String eventEndTime = eventExpression.endTime;
    final String eventLocation = eventExpression.location;
    final String eventImage = eventExpression.photo;
    final String eventDescription = eventExpression.description;

    return Container(
      child: Column(
        children: <Widget>[
          eventImage != ''
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  child: CachedNetworkImage(
                      imageUrl: expression.expressionData.photo,
                      placeholder: (BuildContext context, String _) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                              stops: const <double>[0.2, 0.9],
                              colors: <Color>[
                                Theme.of(context).colorScheme.secondary,
                                Theme.of(context).colorScheme.primary
                              ],
                            ),
                          ),
                        );
                      },
                      fit: BoxFit.cover),
                )
              : const SizedBox(),
          Container(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * .7,
                        child: Text(eventTitle,
                            style: Theme.of(context).textTheme.display1),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.timer,
                              color: Theme.of(context).primaryColor, size: 20),
                          const SizedBox(width: 5),
                          Text(eventStartTime,
                              style: Theme.of(context).textTheme.caption),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.location_searching,
                              color: Theme.of(context).primaryColor, size: 20),
                          const SizedBox(width: 5),
                          Text(eventLocation,
                              style: Theme.of(context).textTheme.caption),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Text(eventDescription,
                          style: Theme.of(context).textTheme.caption),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
