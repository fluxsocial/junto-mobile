import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/comment_open/comment_open.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/widgets/comment_action_items.dart';

/// Shows a preview of the comments. Takes a un-named [String] as a param.
class CommentPreview extends StatelessWidget {
  const CommentPreview(
      {Key key, @required this.commentText, @required this.parent})
      : super(key: key);

  /// String to be displayed as comment
  final String commentText;

  /// Represents the expression
  final dynamic parent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute<dynamic>(
            builder: (BuildContext context) => CommentOpen(commentText, parent),
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
                          builder: (BuildContext context) => JuntoMember(
                            profile: parent.creator,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          ClipOval(
                            child: Image.asset(
                              'assets/images/junto-mobile__eric.png',
                              height: 38.0,
                              width: 38.0,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            child: Text('sunyata',
                                style: Theme.of(context).textTheme.subhead),
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
                          child: CommentActionItems(),
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
                commentText,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text('today', style: Theme.of(context).textTheme.overline),
            ),
          ],
        ),
      ),
    );
  }
}
