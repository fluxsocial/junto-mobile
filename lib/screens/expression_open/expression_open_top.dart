import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/expression_action_items.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';

class ExpressionOpenTop extends StatelessWidget with MemberValidation {
  const ExpressionOpenTop({Key key, this.expression, this.userAddress})
      : super(key: key);

  final ExpressionResponse expression;
  final String userAddress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () => showUserDen(context, expression.creator),
            child: Container(
              color: Colors.transparent,
              child: Row(children: <Widget>[
                MemberAvatar(
                    profilePicture: expression.creator.profilePicture,
                    diameter: 45),
                const SizedBox(width: 10),
                // profile name and handle
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(expression.creator.username.toLowerCase() ?? '',
                          style: Theme.of(context).textTheme.subtitle1),
                      Text('${expression.creator.name}',
                          style: Theme.of(context).textTheme.bodyText1),
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
                builder: (BuildContext context) => ExpressionActionItems(
                    expression: expression, userAddress: userAddress),
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
