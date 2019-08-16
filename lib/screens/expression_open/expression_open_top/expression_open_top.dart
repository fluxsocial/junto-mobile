import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/typography/palette.dart';


class ExpressionOpenTop extends StatelessWidget {
  final expression;

  ExpressionOpenTop(this.expression);

  @override
  Widget build(BuildContext context) {
    String username = expression.username['entry']['username'];
    String firstName = expression.profile['entry']['first_name'];
    String lastName = expression.profile['entry']['last_name'];
    String profilePicture = expression.profile['entry']['profile_picture'];
    String timestamp = expression.timestamp;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(children: [
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
                margin: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      firstName + ' ' + lastName,
                      style: TextStyle(
                          color: JuntoPalette.juntoGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(username,
                        style: TextStyle(
                            color: JuntoPalette.juntoGrey,
                            fontSize: 14,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
            ]),
            Text(timestamp + 'm', style: TextStyle(fontSize: 12))
          ]),
    );
  }
}
