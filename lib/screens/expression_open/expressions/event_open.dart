import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';

class EventOpen extends StatelessWidget {
  const EventOpen(this.expression);

  final CentralizedExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    final CentralizedEventFormExpression eventExpression =
        expression.expressionData as CentralizedEventFormExpression;
    final String eventTitle = eventExpression.title;
    final String eventTime = DateTime.now().toIso8601String();
    // final String eventLocation = eventExpression.location;
    final String eventImage = eventExpression.photo;
    final String eventDescription = eventExpression.description;

    return Container(
      child: Column(
        children: <Widget>[
          eventImage != ''
              ? Container(
                  height: MediaQuery.of(context).size.height * .3,
                  child: Image.asset(eventImage, fit: BoxFit.cover),
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
                      Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1.5),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Text('RSVP'))
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: .75,
                          ),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
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
                          Text('49 members',
                              style: Theme.of(context).textTheme.subtitle),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.timer,
                              color: Theme.of(context).primaryColor, size: 20),
                          const SizedBox(width: 5),
                          Text(eventTime,
                              style: Theme.of(context).textTheme.body2),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, left: 10, right: 10),
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.location_searching,
                              color: Theme.of(context).primaryColor, size: 20),
                          const SizedBox(width: 5),
                          Text('NYC',
                              style: Theme.of(context).textTheme.body2),                          
                          // Text(eventLocation,
                          //     style: Theme.of(context).textTheme.body2),
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
