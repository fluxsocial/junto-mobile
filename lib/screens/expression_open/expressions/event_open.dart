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
                  height: MediaQuery.of(context).size.height * .3,
                  child: Image.asset(eventImage, fit: BoxFit.cover),
                )
              : const SizedBox(),
          Container(
            color: Theme.of(context).colorScheme.background,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(eventTitle, style: Theme.of(context).textTheme.display1),
                const SizedBox(height: 10),
                
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Row(
                    //   children: <Widget>[
                    //     Icon(Icons.timer,
                    //         color: Theme.of(context).primaryColor),
                    //     const SizedBox(width: 5),
                    //     Text(eventTime,
                    //         style: Theme.of(context).textTheme.subtitle),
                    //   ],
                    // ),
                    // const SizedBox(height: 10),
                    // Row(
                    //   children: <Widget>[
                    //     Icon(Icons.location_searching,
                    //         color: Theme.of(context).primaryColor),
                    //     const SizedBox(width: 5),
                    //     Text(eventLocation,
                    //         style: Theme.of(context).textTheme.subtitle),
                    //   ],
                    // ),

                    Row(
                      children: <Widget>[
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__eric.png',
                            height: 28.0,
                            width: 28.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 5),
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__riley.png',
                            height: 28.0,
                            width: 28.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 5),
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__yaz.png',
                            height: 28.0,
                            width: 28.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 5),
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__josh.png',
                            height: 28.0,
                            width: 28.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 5),
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__dora.png',
                            height: 28.0,
                            width: 28.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 5),
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__drea.png',
                            height: 28.0,
                            width: 28.0,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 5),
                        ClipOval(
                          child: Image.asset(
                            'assets/images/junto-mobile__tomis.png',
                            height: 28.0,
                            width: 28.0,
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
