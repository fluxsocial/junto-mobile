import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/screens/comment_open/comment_open_appbar.dart';
import 'package:junto_beta_mobile/widgets/comment_action_items.dart';

class CommentOpen extends StatefulWidget {
  const CommentOpen(this.comment, this.expression);

  final comment;
  final expression;

  @override
  State<StatefulWidget> createState() {
    return CommentOpenState();
  }
}

class CommentOpenState extends State<CommentOpen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: CommentOpenAppbar(),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    'in response to ' + widget.expression.creator.firstName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xff999999),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          color: Colors.white,
                          child: Row(children: <Widget>[
                            // profile picture
                            ClipOval(
                              child: Image.asset(
                                'assets/images/junto-mobile__eric.png',
                                height: 45.0,
                                width: 45.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),

                            // profile name and handle
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'sunyata' ?? '',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'Eric Yang',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff555555),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) =>
                                CommentActionItems(),
                          );
                        },
                        child: Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.all(5),
                          alignment: Alignment.centerRight,
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            color: Color(0xff777777),
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          widget.comment,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 15,
                              height: 1.4,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 7.5),
                  padding: const EdgeInsets.symmetric(
                      horizontal: JuntoStyles.horizontalPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                // expressionTime,
                                'today',
                                textAlign: TextAlign.start,
                                style: JuntoStyles.expressionTimestamp,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
