import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';

class MemberPreview extends StatelessWidget {
  const MemberPreview({Key key, this.profile}) : super(key: key);

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              profile.profilePicture != ''
                  ? ClipOval(
                      child: Image.asset(
                        profile.profilePicture[0],
                        height: 45.0,
                        width: 45.0,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(
                      alignment: Alignment.center,
                      height: 45.0,
                      width: 45.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          stops: const <double>[0.3, 0.9],
                          colors: <Color>[
                            Theme.of(context).colorScheme.secondary,
                            Theme.of(context).colorScheme.primary
                          ],
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Image.asset(
                          'assets/images/junto-mobile__logo--white.png',
                          height: 15)),
              Container(
                width: MediaQuery.of(context).size.width - 75,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
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
                    Text(
                      profile.username,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    Text(profile.name,
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
