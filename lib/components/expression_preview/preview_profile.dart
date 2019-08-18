import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';

import '../../custom_icons.dart';
import '../../screens/member/member.dart';
import '../../typography/style.dart';

class PreviewProfile extends StatelessWidget {
  const PreviewProfile(this.expression);

  final Expression expression;

  @override
  Widget build(BuildContext context) {
    final String firstName = expression.profile['entry']['first_name'];
    final String lastName = expression.profile['entry']['last_name'];
    final String username = expression.username['entry']['username'];
    final String profilePicture =
        expression.profile['entry']['profile_picture'];

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
