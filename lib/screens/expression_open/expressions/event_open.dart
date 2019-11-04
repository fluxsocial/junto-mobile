import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/models/expression.dart';

class EventOpen extends StatelessWidget {
  const EventOpen(this.expression);

  final CentralizedExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    final CentralizedEventFormExpression eventExpression =
        expression.expressionData as CentralizedEventFormExpression;
    final String eventTitle = eventExpression.title;
    final String eventTime = eventExpression.startTime;
    final String eventLocation = eventExpression.location;
    final String eventImage = eventExpression.photo;
    final String eventDescription = eventExpression.description;

    return Container(
      child: Column(
        children: <Widget>[
          eventImage != ''
              ? Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Image.asset(eventImage, fit: BoxFit.fitWidth),
                )
              : const SizedBox(),
          Container(
            color: Theme.of(context).colorScheme.background,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(eventTitle, style: Theme.of(context).textTheme.title),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: <Color>[
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary,
                    ]),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'RSVP',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Icon(Icons.timer,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: 5),
                        Text(eventTime,
                            style: Theme.of(context).textTheme.subtitle),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Icon(Icons.location_searching,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: 5),
                        Text(eventLocation,
                            style: Theme.of(context).textTheme.subtitle),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '90 members going',
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__eric.png',
                            height: 33.0,
                            width: 33.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 5),
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__riley.png',
                            height: 33.0,
                            width: 33.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 5),
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__yaz.png',
                            height: 33.0,
                            width: 33.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 5),
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__josh.png',
                            height: 33.0,
                            width: 33.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 5),
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__dora.png',
                            height: 33.0,
                            width: 33.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 5),
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__drea.png',
                            height: 33.0,
                            width: 33.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 5),
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__tomis.png',
                            height: 33.0,
                            width: 33.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(eventDescription,
                        style: Theme.of(context).textTheme.caption)
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
