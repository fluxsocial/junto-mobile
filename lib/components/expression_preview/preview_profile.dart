import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';

import '../../custom_icons.dart';
import '../../screens/member/member.dart';
import '../../typography/style.dart';

class PreviewProfile extends StatelessWidget {
  const PreviewProfile(this.expression);

  final ExpressionResult expression;

  @override
  Widget build(BuildContext context) {
    final String firstName = expression.result[0].authorProfile.firstName;
    final String lastName = expression.result[0].authorProfile.lastName;
    final String username = expression.result[0].authorUsername.username;
    final String profilePicture =
        expression.result[0].authorProfile.profilePicture;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
                      child: Text(
                        firstName + ' ' + lastName,
                        style: JuntoStyles.expressionPreviewName,
                      ),
                    ),
                    Text(username, style: JuntoStyles.expressionPreviewHandle)
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                child: const Icon(
                  CustomIcons.more,
                  size: 17,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
