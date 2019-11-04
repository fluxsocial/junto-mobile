import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class MemberPreviewSelect extends StatelessWidget {
  const MemberPreviewSelect({Key key, this.profile})
      : super(key: key);

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              ClipOval(
                child: Image.asset(
                  profile.profilePicture,
                  height: 45.0,
                  width: 45.0,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width - 68,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: .5,
                      color: JuntoPalette.juntoFade,
                    ),
                  ),
                ),
                margin: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      profile.username,
                      textAlign: TextAlign.start,
                      style: JuntoStyles.title,
                    ),
                    Text(
                      profile.firstName,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff555555),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
