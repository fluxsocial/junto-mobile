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
import 'package:junto_beta_mobile/widgets/dialogs/user_feedback.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/screens/member/member_action_items/no_relationship_action_items.dart';
import 'package:junto_beta_mobile/screens/member/member_action_items/subscribed_action_items.dart';
import 'package:junto_beta_mobile/screens/member/member_action_items/connected_action_items.dart';
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

  final bool isFollowing;
  final bool isConnected;
  final bool isPending;
  final Function toggleMemberRelationships;
  final Function refreshRelations;
  final UserProfile memberProfile;
  final UserData userProfile;
  final UserRepo userProvider;

  Future<void> subscribeToUser({
    BuildContext buildContext,
    String memberAddress,
  }) async {
    JuntoLoader.showLoader(buildContext);
    try {
      // add member to follow perspective
      await userProvider.addUsersToPerspective(
          userProfile.userPerspective.address, <String>[memberProfile.address]);
      refreshRelations();
      JuntoLoader.hide();
    } on JuntoException catch (error) {
      print(error.message);
      JuntoLoader.hide();
      showDialog(
        context: buildContext,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Hmm, something went wrong.',
        ),
      );
    }
  }

  Future<void> connectWithUser({
    BuildContext buildContext,
    String memberAddress,
  }) async {
    JuntoLoader.showLoader(buildContext);

    // subscribe to user if not already following
    if (!isFollowing) {
      await userProvider.addUsersToPerspective(
          userProfile.userPerspective.address, <String>[memberProfile.address]);
    }
    try {
      await userProvider.connectUser(memberProfile.address);
      refreshRelations();
      JuntoLoader.hide();
      await showFeedback(buildContext, message: 'Connection Sent!');
    } on JuntoException catch (error) {
      print(error);
      JuntoLoader.hide();
      showDialog(
        context: buildContext,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Hmm, something went wrong.',
        ),
      );
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
          } on JuntoException catch (error) {
            JuntoLoader.hide();
            showDialog(
              context: context,
              builder: (BuildContext context) => const SingleActionDialog(
                dialogText: 'Hmm, something went wrong.',
              ),
            );
          }
          Navigator.pop(context);
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
      await showFeedback(context, message: 'Invited to Pack');
      Navigator.pop(context);
    } on JuntoException catch (error) {
      JuntoLoader.hide();
      if (error.message.contains('does not exist or is already a group member'))
        showDialog(
          context: context,
          builder: (BuildContext context) => const SingleActionDialog(
            dialogText: 'Already sent a connection.',
          ),
        );
      if (!error.message
          .contains('does not exist or is already a group member'))
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
            dialogText: error.message,
          ),
        );
    }
  }

  // unsubscribe
  Future<void> _unsubscribeToUser(BuildContext context) async {
    JuntoLoader.showLoader(context);
    try {
      // get address of follow perspective
      final SharedPreferences prefs = await SharedPreferences.getInstance();
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
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Hmm, something went wrong.',
        ),
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
                _displayActionItems(context),
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
                          fontWeight: FontWeight.w700,
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

  Widget _displayActionItems(BuildContext context) {
    if (!isFollowing && !isConnected && !isPending) {
      return NoRelationshipActionItems(
        buildContext: context,
        subscribeToUser: subscribeToUser,
        connectWithUser: connectWithUser,
        userProfile: userProfile,
        memberProfile: memberProfile,
      );
    } else if (isFollowing && !isConnected) {
      return SubscribedActionItems(isPending: isPending);
    } else if (isFollowing && isConnected) {
      return ConnectedActionItems();
    }
    return NoRelationshipActionItems();
  }
}
