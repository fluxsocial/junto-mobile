import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

/// Render a list tile showing the user's profile image.
/// Contains a callback [onUserTap] triggered when the user is selected.
/// If this value is not specified and left null, the user will be redirected to
/// the user "Den".
class MemberPreview extends StatelessWidget {
  const MemberPreview({Key key, this.profile}) : super(key: key);

  final UserProfile profile;

  void _showUserDen(BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute<dynamic>(
        builder: (BuildContext context) => JuntoMember(profile: profile),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showUserDen(context);
      },
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Row(
          children: <Widget>[
            profile.profilePicture.isNotEmpty
                ? ClipOval(
                    child: CachedNetworkImage(
                        imageUrl: profile.profilePicture[0],
                        height: 45,
                        width: 45,
                        fit: BoxFit.cover,
                        placeholder: (BuildContext context, String _) {
                          return Container(
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
                                  Theme.of(context).colorScheme.primary,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Icon(
                              CustomIcons.spheres,
                              color: Theme.of(context).colorScheme.onPrimary,
                              size: 17,
                            ),
                          );
                        }),
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
                        height: 15),
                  ),
            Container(
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
                  Text(
                    profile.username,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(profile.name,
                      textAlign: TextAlign.start,
                      style: Theme.of(context).textTheme.bodyText1)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
