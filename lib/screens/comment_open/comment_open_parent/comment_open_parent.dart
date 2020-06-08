import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';

import 'types/dynamic_parent.dart';

class CommentOpenParent extends StatelessWidget {
  const CommentOpenParent({
    this.comment,
    this.parent,
  });
  final Comment comment;
  final dynamic parent;

  @override
  Widget build(BuildContext context) {
    _buildBody() {
      switch (parent.type) {
        case 'LongForm':
          return DynamicParent(
            expression: parent,
          );
          break;
        case 'ShortForm':
          return DynamicParent(
            expression: parent,
          );
          break;
        case 'PhotoForm':
          return DynamicParent(
            expression: parent,
          );
          break;
        case 'AudioForm':
          return DynamicParent(
            expression: parent,
          );
          break;
      }
    }

    print(parent.type);
    return Container(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
      ),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            child: Row(children: <Widget>[
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
                child: _buildBody(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
