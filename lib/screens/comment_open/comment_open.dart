import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/comment_open/comment_open_appbar.dart';
import 'package:junto_beta_mobile/widgets/comment_action_items.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:junto_beta_mobile/widgets/utils/date_parsing.dart';

class CommentOpen extends StatelessWidget {
  const CommentOpen(this.comment, this.parent, this.userAddress);

  final dynamic comment;
  final dynamic parent;
  final String userAddress;

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
                    'in response to ' + parent.creator.name,
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
                            comment.creator.profilePicture.isNotEmpty
                                ? ClipOval(
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            comment.creator.profilePicture[0],
                                        height: 45,
                                        width: 45,
                                        fit: BoxFit.cover,
                                        placeholder:
                                            (BuildContext context, String _) {
                                          return Container(
                                            alignment: Alignment.center,
                                            height: 45.0,
                                            width: 45.0,
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomLeft,
                                                end: Alignment.topRight,
                                                stops: const <double>[0.3, 0.9],
                                                colors: <Color>[
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                ],
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                            ),
                                            child: Image.asset(
                                                'assets/images/junto-mobile__logo--white.png',
                                                height: 17),
                                          );
                                        }),
                                  )
                                :
                                // profile picture
                                Container(
                                    alignment: Alignment.center,
                                    height: 45.0,
                                    width: 45.0,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.bottomLeft,
                                        end: Alignment.topRight,
                                        stops: const <double>[0.3, 0.9],
                                        colors: <Color>[
                                          Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          Theme.of(context).colorScheme.primary,
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Image.asset(
                                        'assets/images/junto-mobile__logo--white.png',
                                        height: 17),
                                  ),
                            const SizedBox(width: 10),

                            // profile name and handle
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(comment.creator.username,
                                      style: Theme.of(context)
                                          .textTheme
                                          .subtitle1),
                                  Text(comment.creator.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1),
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
                                CommentActionItems(
                              comment: comment,
                              userAddress: userAddress,
                              source: 'open'
                            ),
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
                        child: Text(comment.expressionData.body,
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
                                  parseDate(context, comment.createdAt)
                                      .toLowerCase(),
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
