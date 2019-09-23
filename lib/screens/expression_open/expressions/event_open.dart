import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/models/expression.dart';

class EventOpen extends StatelessWidget {
  const EventOpen(this.expression);

  final Expression expression;

  @override
  Widget build(BuildContext context) {
    final String eventTitle = expression.expression.expressionContent['title'];
    final String eventTime = expression.expression.expressionContent['time'];
    final String eventLocation =
        expression.expression.expressionContent['location'];
    final String eventImage = expression.expression.expressionContent['image'];
    final String eventDescription =
        expression.expression.expressionContent['description'];

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
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  eventTitle,
                  style: const TextStyle( 
                      color: JuntoPalette.juntoGrey,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  height: 50,
                  // width: MediaQuery.of(context).size.width * .8,
                  // height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: <Color>[
                      JuntoPalette.juntoSecondary,
                      JuntoPalette.juntoPrimary
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
                    Text(
                      eventTime,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      eventLocation,
                      style: const TextStyle(
                          fontSize: 17, fontWeight: FontWeight.w600),
                    ),
                    // SizedBox(height: 5),
                    // Text(
                    //   'hosted by',
                    //   style:
                    //       TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                    // ),
                    const SizedBox(height: 5),
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
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      eventDescription,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                          height: 1.5),
                    ),
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
