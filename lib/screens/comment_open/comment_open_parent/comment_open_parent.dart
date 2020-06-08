import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:junto_beta_mobile/widgets/action_items/comment_action_items.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

import 'types/audio_parent.dart';
import 'types/dynamic_parent.dart';
import 'types/photo_parent.dart';
import 'types/shortform_parent.dart';

class CommentOpenParent extends StatelessWidget {
  const CommentOpenParent({
    @required this.comment,
    @required this.parent,
    @required this.userAddress,
  });
  final Comment comment;
  final dynamic parent;
  final String userAddress;

  @override
  Widget build(BuildContext context) {
    Widget _buildBody() {
      switch (parent.type) {
        case 'LongForm':
          return DynamicParent(
            expression: parent,
          );
          break;
        case 'ShortForm':
          return ShortformParent(
            expression: parent,
          );
          break;
        case 'PhotoForm':
          return PhotoParent(
            expression: parent,
          );
          break;
        case 'AudioForm':
          return AudioParent(
            expression: parent,
          );
          break;
      }
      return SizedBox();
    }

    return Container(
      padding: const EdgeInsets.only(
        top: 10,
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      MemberAvatar(
                        profilePicture: parent.creator.profilePicture,
                        diameter: 45,
                      ),
                      const SizedBox(width: 10),
                      // profile name and handle

                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              parent.creator.username,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              parent.creator.name,
                              style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                      ),
                    ],
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
                ]),
          ),
          Row(
            children: <Widget>[
              Container(
                width: 45,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: _buildBody(),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
