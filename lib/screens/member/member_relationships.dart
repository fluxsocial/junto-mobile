import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemberRelationships extends StatelessWidget {
  const MemberRelationships({
    this.isFollowing,
    this.isConnected,
    this.isPending,
    this.userProvider,
    this.userProfile,
    this.toggleMemberRelationships,
    this.memberProfile,
    this.refreshRelations,
  });

  final ValueNotifier<bool> isFollowing;
  final ValueNotifier<bool> isConnected;
  final ValueNotifier<bool> isPending;
  final Function toggleMemberRelationships;
  final Function refreshRelations;
  final UserProfile memberProfile;
  final UserData userProfile;
  final UserRepo userProvider;

  Future<void> _subscribeToUser(BuildContext context) async {
    JuntoLoader.showLoader(context);
    try {
      // get address of follow perspective
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> decodedUserData =
          jsonDecode(prefs.getString('user_data'));
      final UserData userProfile = UserData.fromMap(decodedUserData);
      // add member to follow perspective
      await userProvider.addUsersToPerspective(
          userProfile.userPerspective.address, <String>[memberProfile.address]);

      refreshRelations();

      JuntoLoader.hide();
    } on JuntoException catch (error) {
      JuntoLoader.hide();
      JuntoDialog.showJuntoDialog(
          context, 'Error occured ${error?.message}', <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ok'),
        )
      ]);
    }
  }

  Future<void> _unsubscribeToUser(BuildContext context) async {
    JuntoDialog.showJuntoDialog(
        context, 'Are you sure you want to unsubscribe?', <Widget>[
      FlatButton(
        onPressed: () async {
          JuntoLoader.showLoader(context);
          try {
            // get address of follow perspective
            final SharedPreferences prefs =
                await SharedPreferences.getInstance();
            final Map<String, dynamic> decodedUserData =
                jsonDecode(prefs.getString('user_data'));
            final UserData userProfile = UserData.fromMap(decodedUserData);
            // add member to follow perspective
            await userProvider.deleteUsersFromPerspective(
              <Map<String, String>>[
                <String, String>{'user_address': memberProfile.address}
              ],
              userProfile.userPerspective.address,
            );

            refreshRelations();

            JuntoLoader.hide();
            Navigator.pop(context);
          } on JuntoException catch (error) {
            JuntoLoader.hide();
            JuntoDialog.showJuntoDialog(
                context, 'Error occured ${error?.message}', <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              )
            ]);
          }
        },
        child: const Text('Yes'),
      ),
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('No'),
      ),
    ]);
  }

  Future<void> _connectWithUser(BuildContext context) async {
    JuntoLoader.showLoader(context);
    try {
      await userProvider.connectUser(memberProfile.address);
      refreshRelations();
      JuntoLoader.hide();
      JuntoDialog.showJuntoDialog(context, 'Connection Sent', <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ok'),
        )
      ]);
    } on JuntoException catch (error) {
      JuntoLoader.hide();
      JuntoDialog.showJuntoDialog(
          context, 'Error occured ${error?.message}', <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ok'),
        )
      ]);
    }
  }

  Future<void> _disconnectWithUser(BuildContext context) async {
    JuntoDialog.showJuntoDialog(
        context, 'Are you sure you want to disconnect?', <Widget>[
      FlatButton(
        onPressed: () async {
          try {
            JuntoLoader.showLoader(context);
            await userProvider.removeUserConnection(memberProfile.address);
            refreshRelations();
            JuntoLoader.hide();
            Navigator.pop(context);
          } on JuntoException catch (error) {
            JuntoLoader.hide();
            JuntoDialog.showJuntoDialog(
                context, 'Error occured ${error?.message}', <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              )
            ]);
          }
        },
        child: const Text('Yes'),
      ),
      FlatButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('No'),
      ),
    ]);
  }

  Future<void> _inviteToPack(BuildContext context) async {
    JuntoLoader.showLoader(context);
    try {
      await Provider.of<GroupRepo>(context, listen: false).addGroupMember(
          userProfile.pack.address, <UserProfile>[memberProfile], 'Member');
      refreshRelations();
      JuntoLoader.hide();
      JuntoDialog.showJuntoDialog(context, 'Invited to Pack', <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Ok'),
        )
      ]);
    } on JuntoException catch (error) {
      JuntoLoader.hide();
      if (error.message.contains('does not exist or is already a group member'))
        JuntoDialog.showJuntoDialog(
          context,
          'Connection already sent',
          <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            )
          ],
        );
      if (!error.message
          .contains('does not exist or is already a group member'))
        JuntoDialog.showJuntoDialog(
          context,
          '${error.message}',
          <Widget>[
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            )
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xff222222).withOpacity(.8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const SizedBox(),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset('assets/images/junto-mobile__logo.png', height: 24),
                const SizedBox(height: 15),
                AnimatedBuilder(
                    animation: Listenable.merge(<ValueNotifier<bool>>[
                      isFollowing,
                      isPending,
                      isConnected,
                    ]),
                    builder: (BuildContext context, _) {
                      return _buildRelationShips(context);
                    }),
                const SizedBox(height: 15),
                GestureDetector(
                  onTap: toggleMemberRelationships,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 25),
                    child: Text(
                      'CLOSE',
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).primaryColor,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox()
        ],
      ),
    );
  }

  Widget _buildRelationShips(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (isFollowing.value) {
              _unsubscribeToUser(context);
            } else {
              _subscribeToUser(context);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).dividerColor, width: .5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'SUBSCRIBE',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.none,
                      letterSpacing: 1.2),
                ),
                AnimatedCrossFade(
                  crossFadeState: isFollowing.value
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                  firstChild: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  secondChild: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).backgroundColor,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const <double>[0.1, 0.9],
                        colors: <Color>[
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.primary
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (isPending.value) {
              _disconnectWithUser(context);
            } else {
              _connectWithUser(context);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).dividerColor, width: .5),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'CONNECT',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.none,
                          letterSpacing: 1.2),
                    ),
                    if (isPending.value)
                      Container(
                        margin: const EdgeInsets.only(top: 2.5),
                        child: Text(
                          'PENDING',
                          style: Theme.of(context).textTheme.overline,
                        ),
                      )
                  ],
                ),
                AnimatedCrossFade(
                  crossFadeState: isPending.value
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                  firstChild: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.add,
                      size: 15,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  secondChild: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).backgroundColor,
                        width: 1.2,
                      ),
                      borderRadius: BorderRadius.circular(5),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: const <double>[0.1, 0.9],
                        colors: <Color>[
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context).colorScheme.primary
                        ],
                      ),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            _inviteToPack(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border(
                bottom: BorderSide(
                    color: Theme.of(context).dividerColor, width: .5),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'INVITE TO PACK',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                      decoration: TextDecoration.none,
                      letterSpacing: 1.2),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 1.2),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(Icons.add,
                      size: 15, color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
