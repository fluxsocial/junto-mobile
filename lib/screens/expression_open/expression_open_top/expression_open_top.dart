import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/components/expression_action_items/expression_action_items.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/typography/palette.dart';

class ExpressionOpenTop extends StatelessWidget {
  const ExpressionOpenTop({Key key, this.expression}) : super(key: key);

  final Expression expression;

  @override
  Widget build(BuildContext context) {
    final String username = expression.authorUsername.username;
    final String firstName = expression.authorProfile.firstName;
    final String lastName = expression.authorProfile.lastName;
    final String profilePicture = expression.authorProfile.profilePicture;
    // ignore: unused_local_variable
    final String timestamp = expression.timestamp;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(children: <Widget>[
            // profile picture
            ClipOval(
              child: Image.asset(
                profilePicture,
                height: 36.0,
                width: 36.0,
                fit: BoxFit.cover,
              ),
            ),

            // profile name and handle
            Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    firstName + ' ' + lastName,
                    style: const TextStyle(
                        color: JuntoPalette.juntoGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    '@' + username,
                    style: const TextStyle(
                      color: JuntoPalette.juntoGrey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ]),
          GestureDetector(
            onTap: () {
              ExpressionActionItems().buildExpressionActionItems(context);
            },
            child: const Icon(
              CustomIcons.more,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
