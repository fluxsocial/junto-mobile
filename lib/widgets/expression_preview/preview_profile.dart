import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/styles.dart';
import 'package:junto_beta_mobile/widgets/expression_action_items/expression_action_items.dart';

class PreviewProfile extends StatelessWidget {
  const PreviewProfile({
    Key key,
    this.expression,
  }) : super(key: key);

  final CentralizedExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    final String firstName = expression.creator.firstName;
    final String lastName = expression.creator.lastName;
    final String username = expression.creator.username;
    final String profilePicture = expression.creator.profilePicture;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: JuntoStyles.horizontalPadding, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute<dynamic>(
                  builder: (
                    BuildContext context,
                  ) =>
                      JuntoMember(),
                ),
              );
            },
            child: Container(
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // profile picture
                  ClipOval(
                    child: Image.asset(
                      profilePicture,
                      height: 36.0,
                      width: 36.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(

                    margin: const EdgeInsets.only(left: 7.5),
                    child: Text(
                      username,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),

                    ),
                  )

                  // profile name and handle
                  // Container(
                  //   margin: const EdgeInsets.only(left: 10.0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: <Widget>[
                  //       Text(firstName + ' ' + lastName,
                  //           style: JuntoStyles.title),
                  //       Text(username, style: JuntoStyles.body)
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  ExpressionActionItems().buildExpressionActionItems(context);
                },
                child: const Icon(
                  CustomIcons.more,
                  size: 20,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
