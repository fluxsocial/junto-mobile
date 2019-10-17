import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/styles.dart';
import 'package:junto_beta_mobile/widgets/expression_action_items.dart';

class ExpressionOpenTop extends StatelessWidget {
  const ExpressionOpenTop({Key key, this.expression}) : super(key: key);

  final CentralizedExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    final String username = expression.creator.username;
    final String firstName = expression.creator.firstName;
    final String lastName = expression.creator.lastName;
    final String profilePicture = expression.creator.profilePicture;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
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
                    profile: UserProfile(
                      address: '',
                      firstName: firstName,
                      lastName: lastName,
                      bio: 'This is a test',
                      profilePicture: 'assets/images/junto-mobile__logo.png',
                      username: 'Gmail',
                      verified: false,
                    ),
                  ),
                ),
              );
            },
            child: Container(
              color: Colors.white,
              child: Row(children: <Widget>[
                // profile picture
                ClipOval(
                  child: Image.asset(
                    profilePicture,
                    height: 38.0,
                    width: 38.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 10),

                // profile name and handle
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(username ?? '', style: JuntoStyles.title),
                      Text(
                        firstName + ' ' + lastName,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff555555),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
          GestureDetector(
            onTap: () {
              ExpressionActionItems().buildExpressionActionItems(context);
            },
            child: const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xff555555),
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
