import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:junto_beta_mobile/widgets/action_items/comment_action_items.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/models/models.dart';

class CommentOpenTop extends StatelessWidget {
  const CommentOpenTop({
    this.comment,
    this.userAddress,
  });
  final Comment comment;
  final String userAddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
        bottom: 15,
        left: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute<Widget>(
                  builder: (BuildContext context) => JuntoMember(
                    profile: comment.creator,
                  ),
                ),
              );
            },
            child: Container(
              color: Colors.transparent,
              child: Row(children: <Widget>[
                MemberAvatar(
                  profilePicture: comment.creator.profilePicture,
                  diameter: 45,
                ),
                const SizedBox(width: 10),

                // profile name and handle
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        comment.creator.username,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        comment.creator.name,
                        style: Theme.of(context).textTheme.bodyText1,
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                builder: (BuildContext context) => CommentActionItems(
                  comment: comment,
                  userAddress: userAddress,
                  source: 'open',
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
    );
  }
}
