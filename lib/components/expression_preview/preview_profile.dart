import 'package:flutter/material.dart';
import '../../typography/style.dart';
import '../../custom_icons.dart';

import '../../screens/member/member.dart';

class PreviewProfile extends StatelessWidget {
  final expression;

  PreviewProfile(this.expression);
  @override
  Widget build(BuildContext context) {
    String firstName = expression.profile['entry']['first_name'];
    String lastName = expression.profile['entry']['last_name'];
    String username = expression.username['entry']['username']; 
    String profilePicture = expression.profile['entry']['profile_picture'];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
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
              margin: EdgeInsets.only(left: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => JuntoMember()
                      ))
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
          ]),
          Row(children: [          
            Container(child: Icon(CustomIcons.more, size: 17))
          ])
        ],
      ),
    );
  }
}
