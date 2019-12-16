import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/comment_open/comment_open_appbar.dart';
import 'package:junto_beta_mobile/widgets/comment_action_items.dart';

class CommentOpen extends StatefulWidget {
  const CommentOpen(this.comment, this.parent);

  final dynamic comment;
  final dynamic parent;

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
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                  child: Text(
                    'in response to ' + widget.parent.creator.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColorLight,
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
                          color: Colors.transparent,
                          child: Row(children: <Widget>[
                            // profile picture
                            ClipOval(
                              child: Image.asset(
                                'assets/images/junto-mobile__placeholder--member.png',
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
                                  Text(widget.comment.creator.username,
                                      style:
                                          Theme.of(context).textTheme.subhead),
                                  Text(widget.comment.creator.name,
                                      style: Theme.of(context).textTheme.body1),
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
                          padding: const EdgeInsets.all(5),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            CustomIcons.morevertical,
                            color: Theme.of(context).primaryColor,
                            size: 20,
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
                        child: Text(widget.comment.expressionData.body,
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.caption),
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
                                  style: Theme.of(context).textTheme.overline),
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
