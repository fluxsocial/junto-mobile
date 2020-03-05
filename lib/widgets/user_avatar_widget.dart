import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';

/// Generic widget which accepts [UserProfile].
/// Widget displays the user's profile or Junto's white logo depending on the
/// value of [user.profilePicture.first]
class JuntoUserAvatar extends StatelessWidget {
  const JuntoUserAvatar({
    Key key,
    @required this.user,
  }) : super(key: key);
  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    if (user != null && user.profilePicture.isNotEmpty)
      return Container(
        margin: const EdgeInsets.only(right: 32),
        child: ClipOval(
          child: CachedNetworkImage(
            imageUrl: user.profilePicture.first,
            height: 28,
            width: 28,
            fit: BoxFit.cover,
            placeholder: (BuildContext context, String _) {
              return Container(
                alignment: Alignment.center,
                height: 28.0,
                width: 28.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: const <double>[0.3, 0.9],
                    colors: <Color>[
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Image.asset(
                  'assets/images/junto-mobile__logo--white.png',
                  height: 17,
                ),
              );
            },
          ),
        ),
      );
    return Container(
      alignment: Alignment.center,
      height: 28.0,
      width: 28.0,
      margin: const EdgeInsets.only(right: 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          stops: const <double>[0.3, 0.9],
          colors: <Color>[
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Image.asset(
        'assets/images/junto-mobile__logo--white.png',
        height: 12,
      ),
    );
  }
}
