import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoRelationshipActionItems extends StatelessWidget {
  const NoRelationshipActionItems({
    this.buildContext,
    this.subscribeToUser,
    this.connectWithUser,
    this.inviteToPack,
    this.userProfile,
    this.memberProfile,
  });

  final BuildContext buildContext;
  final userProfile;
  final memberProfile;
  final subscribeToUser;
  final connectWithUser;
  final inviteToPack;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            subscribeToUser(
              buildContext: buildContext,
              userAddress: userProfile.user.address,
              memberAddress: memberProfile.address,
            );
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
                      fontWeight: FontWeight.w700,
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
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(Icons.add,
                      size: 15, color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            connectWithUser(
              buildContext: buildContext,
              memberAddress: memberProfile.address,
            );
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
                Text(
                  'CONNECT',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
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
                      borderRadius: BorderRadius.circular(5)),
                  child: Icon(Icons.add,
                      size: 15, color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
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
                      fontWeight: FontWeight.w700,
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
