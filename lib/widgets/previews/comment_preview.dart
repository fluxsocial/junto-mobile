import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/comment_open/comment_open.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/widgets/comment_action_items.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:junto_beta_mobile/widgets/utils/date_parsing.dart';

/// Shows a preview of the comments. Takes a un-named [String] as a param.
class CommentPreview extends StatelessWidget {
  const CommentPreview(
      {Key key,
      @required this.comment,
      @required this.parent,
      @required this.userAddress})
      : super(key: key);

  /// comment
  final Comment comment;

  // parent expression of comment
  final dynamic parent;

  // address of user
  final String userAddress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute<dynamic>(
            builder: (BuildContext context) =>
                CommentOpen(comment, parent, userAddress),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        color: Theme.of(context).colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // comment preview top
            Container(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              JuntoMember(profile: comment.creator),
                        ),
                      );
                    },
                    child: Container(
                      child: Row(
                        children: <Widget>[
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
                                        Theme.of(context).colorScheme.secondary,
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
                          Container(
                            child: Text(comment.creator.username,
                                style: Theme.of(context).textTheme.subtitle1),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) => Container(
                          color: Colors.transparent,
                          child: CommentActionItems(
                            comment: comment,
                            userAddress: userAddress,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        CustomIcons.morevertical,
                        size: 20,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // comment preview body
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                comment.expressionData.body,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                parseDate(context, comment.createdAt).toLowerCase(),
                style: Theme.of(context).textTheme.overline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
