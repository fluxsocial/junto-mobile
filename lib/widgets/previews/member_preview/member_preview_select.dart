import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class MemberPreviewSelect extends StatelessWidget {
  const MemberPreviewSelect({Key key, this.profile}) : super(key: key);

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
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
                width: MediaQuery.of(context).size.width - 75,
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: .5,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
                margin: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(profile.username,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.subhead),
                    Text(profile.firstName,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.body1)
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
