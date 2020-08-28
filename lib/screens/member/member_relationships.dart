import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/member/member_action_items/pack_action_items.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/screens/member/member_action_items/no_relationship_action_items.dart';
import 'package:junto_beta_mobile/screens/member/member_action_items/subscribed_action_items.dart';
import 'package:junto_beta_mobile/screens/member/member_action_items/connected_action_items.dart';
import 'package:provider/provider.dart';

class MemberRelationships extends StatelessWidget {
  const MemberRelationships({
    Key key,
    this.isFollowing,
    this.isConnected,
    this.hasPendingConnection,
    this.hasPendingPackRequest,
    this.isPackMember,
    this.userProvider,
    this.userProfile,
    this.toggleMemberRelationships,
    this.memberProfile,
    this.refreshRelations,
    this.groupProvider,
  }) : super(key: key);

  final bool isFollowing;
  final bool isConnected;
  final bool hasPendingConnection;
  final bool hasPendingPackRequest;
  final bool isPackMember;
  final Function toggleMemberRelationships;
  final Function refreshRelations;
  final UserProfile memberProfile;
  final UserData userProfile;
  final UserRepo userProvider;
  final GroupRepo groupProvider;

  Future<void> subscribeToUser(BuildContext buildContext) async {
    try {
      // add member to follow perspective
      await userProvider.addUsersToPerspective(
          userProfile.userPerspective.address, <String>[memberProfile.address]);
      refreshRelations();
    } on JuntoException catch (error) {
      logger.logException(error);
      showDialog(
        context: buildContext,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: S.of(context).common_network_error,
        ),
      );
    }
  }

  // unsubscribe
  Future<void> unsubscribeToUser({buildContext}) async {
    await userProvider.deleteUsersFromPerspective(
      <Map<String, String>>[
        <String, String>{'user_address': memberProfile.address}
      ],
      userProfile.userPerspective.address,
    );
    refreshRelations();
  }

  Future<void> connectWithUser(
    BuildContext buildContext,
  ) async {
    // subscribe to user if not already following
    if (!isFollowing) {
      await userProvider.addUsersToPerspective(
          userProfile.userPerspective.address, <String>[memberProfile.address]);
    }
    try {
      await userProvider.connectUser(memberProfile.address);
      refreshRelations();
    } on JuntoException catch (error) {
      logger.logException(error);
      showDialog(
        context: buildContext,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: S.of(context).common_network_error,
        ),
      );
    }
  }

  Future<void> disconnectWithUser() async {
    await userProvider.removeUserConnection(memberProfile.address);
    refreshRelations();
  }

  Future<void> inviteToPack(BuildContext buildContext) async {
    try {
      // subscribe to user if not already following
      if (!isFollowing) {
        await userProvider.addUsersToPerspective(
            userProfile.userPerspective.address,
            <String>[memberProfile.address]);
      }

      // send connection to user if there isn't an existing request of connection
      if (!hasPendingConnection && !isConnected) {
        await userProvider.connectUser(memberProfile.address);
      }

      await Provider.of<GroupRepo>(buildContext, listen: false).addGroupMember(
          userProfile.pack.address, <UserProfile>[memberProfile], 'Member');
      refreshRelations();
    } on JuntoException catch (error) {
      if (error.message
          .contains('does not exist or is already a group member')) {
        showDialog(
          context: buildContext,
          builder: (BuildContext context) => SingleActionDialog(
            dialogText: S.of(context).error_already_sent_connection,
          ),
        );
      }
      if (!error.message
          .contains('does not exist or is already a group member')) {
        showDialog(
          context: buildContext,
          builder: (BuildContext context) => SingleActionDialog(
            dialogText: error.message,
          ),
        );
      }
    } catch (e) {
      logger.logException(e);
    }
  }

  Future<void> leavePack() async {
    await groupProvider.removeGroupMember(
      userProfile.pack.address,
      memberProfile.address,
    );
    refreshRelations();
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
            padding: const EdgeInsets.only(
              top: 25,
              left: 25,
              right: 25,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  'assets/images/junto-mobile__logo.png',
                  height: 24,
                  color: Theme.of(context).primaryColor,
                ),
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
                      S.of(context).common_close,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).primaryColor,
                        letterSpacing: 1.4,
                        fontWeight: FontWeight.w700,
                        decoration: TextDecoration.none,
                      ),
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

  Widget _displayActionItems(BuildContext buildContext) {
    if (!isFollowing &&
        !isConnected &&
        !hasPendingConnection &&
        !hasPendingPackRequest &&
        !isPackMember) {
      logger.logInfo('No Relationship Action Items');
      return NoRelationshipActionItems(
        buildContext: buildContext,
        subscribeToUser: subscribeToUser,
        connectWithUser: connectWithUser,
        inviteToPack: inviteToPack,
      );
    } else if (isFollowing &&
        !isConnected &&
        !hasPendingConnection &&
        !hasPendingPackRequest &&
        !isPackMember) {
      logger.logInfo('Subscribed Action Items');
      return SubscribedActionItems(
        buildContext: buildContext,
        unsubscribeToUser: unsubscribeToUser,
        connectWithUser: connectWithUser,
        inviteToPack: inviteToPack,
      );
    } else if (isConnected &&
            hasPendingPackRequest != true &&
            isPackMember != true ||
        hasPendingConnection &&
            hasPendingPackRequest != true &&
            isPackMember != true) {
      logger.logInfo('Connected Action Items');
      return ConnectedActionItems(
        buildContext: buildContext,
        subscribeToUser: subscribeToUser,
        unsubscribeToUser: unsubscribeToUser,
        disconnectWithUser: disconnectWithUser,
        inviteToPack: inviteToPack,
        hasPendingConnection: hasPendingConnection,
        isConnected: isConnected,
        isFollowing: isFollowing,
      );
    } else if (hasPendingPackRequest || isPackMember) {
      logger.logInfo('Pack Action Items');
      return PackActionItems(
        buildContext: buildContext,
        subscribeToUser: subscribeToUser,
        unsubscribeToUser: unsubscribeToUser,
        disconnectWithUser: disconnectWithUser,
        inviteToPack: inviteToPack,
        hasPendingConnection: hasPendingConnection,
        isConnected: isConnected,
        isFollowing: isFollowing,
        hasPendingPackRequest: hasPendingPackRequest,
        isPackMember: isPackMember,
        leavePack: leavePack,
      );
    }
    logger.logInfo('No Relationship Action Items');
    return NoRelationshipActionItems(
      buildContext: buildContext,
      subscribeToUser: subscribeToUser,
      connectWithUser: connectWithUser,
      inviteToPack: inviteToPack,
    );
  }
}
