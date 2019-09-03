import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/components/expression_action_items/expression_action_items.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/styles.dart';

class PreviewProfile extends StatelessWidget {
  const PreviewProfile({
    Key key,
    this.expression,
  }) : super(key: key);

  final Expression expression;

  @override
  Widget build(BuildContext context) {
    final String firstName = expression.authorProfile.firstName;
    final String lastName = expression.authorProfile.lastName;
    final String username = expression.authorUsername.username;
    final String profilePicture = expression.authorProfile.profilePicture;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: JuntoStyles.horizontalPadding, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
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

              // profile name and handle
              Container(
                margin: const EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (
                              BuildContext context,
                            ) =>
                                JuntoMember(),
                          ),
                        );
                      },
                      child: Text(firstName + ' ' + lastName,
                          style: JuntoStyles.title),
                    ),
                    Text(username, style: JuntoStyles.body)
                  ],
                ),
              ),
            ],
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
