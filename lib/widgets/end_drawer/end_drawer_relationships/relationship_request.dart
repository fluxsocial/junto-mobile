import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/avatars/member_avatar.dart';
import 'package:provider/provider.dart';

class RelationshipRequest extends StatelessWidget {
  const RelationshipRequest(this.user, this.onAction);

  ///  Called whenever a user is accepted or rejected.
  final Function onAction;
  final UserProfile user;

  Future<void> _acceptConnection(
    BuildContext context,
    UserProfile _connection,
  ) async {
    try {
      JuntoLoader.showLoader(context);
      await Provider.of<UserRepo>(context, listen: false).respondToConnection(
        user.address,
        true,
      );
      JuntoLoader.hide();
      onAction(true);
    } on JuntoException catch (error) {
      JuntoLoader.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Hmm, something went wrong.',
        ),
      );
      print('Error accepting connection ${error.message}');
    }
  }

  Future<void> _rejectConnection(
    BuildContext context,
    UserProfile _connection,
  ) async {
    try {
      JuntoLoader.showLoader(context);
      await Provider.of<UserRepo>(context, listen: false).respondToConnection(
        user.address,
        false,
      );
      JuntoLoader.hide();
      onAction(false);
    } on JuntoException catch (error) {
      JuntoLoader.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Hmm, something went wrong.',
        ),
      );
      print('Error rejecting connection ${error.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute<dynamic>(
            builder: (BuildContext context) => JuntoMember(profile: user),
          ),
        );
      },
      child: Container(
        color: Theme.of(context).colorScheme.background,
        child: Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                MemberAvatar(profilePicture: user.profilePicture, diameter: 45),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              user.username,
                              textAlign: TextAlign.start,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(user.name,
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.bodyText1)
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _acceptConnection(context, user),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1,
                            ),
                          ),
                          height: 38,
                          width: 38,
                          child: Icon(
                            CustomIcons.check,
                            size: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => _rejectConnection(context, user),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(100),
                            border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 1),
                          ),
                          height: 38,
                          width: 38,
                          child: Icon(CustomIcons.cancel,
                              size: 20, color: Theme.of(context).primaryColor),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
