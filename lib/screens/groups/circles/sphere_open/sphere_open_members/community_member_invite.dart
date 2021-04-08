import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';

/// Render a list tile showing the user's profile image.
/// Contains a callback [onUserTap] triggered when the user is selected.
/// If this value is not specified and left null, the user will be redirected to
/// the user "Den".
class CommunityMemberInvite extends StatelessWidget with MemberValidation {
  const CommunityMemberInvite({Key key, this.profile, this.onUserTap})
      : super(key: key);

  final UserProfile profile;
  final VoidCallback onUserTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (onUserTap != null) {
          onUserTap();
        } else {
          if (await isHostUser(profile)) {
            Navigator.pop(context);
          }
          showUserDen(context, profile);
        }
      },
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MemberAvatar(
              diameter: 45,
              profilePicture: profile.profilePicture,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: .5,
                      color: Theme.of(context).dividerColor,
                    ),
                  ),
                ),
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
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(5),
                // border: Border.all(
                //   color: Theme.of(context).dividerColor,
                //   width: .75,
                // ),
              ),
              child: Text(
                'Invite',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
