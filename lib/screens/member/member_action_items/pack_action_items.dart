import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/dialogs/confirm_dialog.dart';

class PackActionItems extends StatelessWidget {
  const PackActionItems({
    this.buildContext,
    this.isFollowing,
    this.hasPendingConnection,
    this.hasPendingPackRequest,
    this.isPackMember,
    this.isConnected,
    this.subscribeToUser,
    this.unsubscribeToUser,
    this.disconnectWithUser,
    this.inviteToPack,
    this.leavePack,
  });

  final BuildContext buildContext;
  final bool isFollowing;
  final bool hasPendingConnection;
  final bool hasPendingPackRequest;
  final bool isPackMember;
  final bool isConnected;
  final Function subscribeToUser;
  final Function unsubscribeToUser;
  final Function disconnectWithUser;
  final Function inviteToPack;
  final Function leavePack;

  @override
  Widget build(BuildContext context) {
    print('Pack Action Items');
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            isFollowing
                ? showDialog(
                    context: context,
                    builder: (BuildContext context) => ConfirmDialog(
                      buildContext: buildContext,
                      confirmationText: 'Are you sure you want to unsubscribe?',
                      confirm: unsubscribeToUser,
                    ),
                  )
                : subscribeToUser(buildContext);
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
                  isFollowing ? 'SUBSCRIBED' : 'SUBSCRIBE',
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
                  decoration: isFollowing
                      ? BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).backgroundColor,
                              width: 1.2),
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
                        )
                      : BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                  child: isFollowing
                      ? Icon(Icons.check, size: 15, color: Colors.white)
                      : Icon(Icons.add,
                          size: 15, color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (!hasPendingConnection) {
              disconnectWithUser(buildContext);
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
                      hasPendingConnection ? 'CONNECT' : 'CONNECTED',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.none,
                          letterSpacing: 1.2),
                    ),
                    hasPendingConnection
                        ? Container(
                            margin: const EdgeInsets.only(top: 2.5),
                            child: Text('PENDING',
                                style: Theme.of(context).textTheme.overline))
                        : const SizedBox()
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: hasPendingConnection || isConnected
                      ? BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).backgroundColor,
                              width: 1.2),
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
                        )
                      : BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.2),
                          borderRadius: BorderRadius.circular(5),
                        ),
                  child: hasPendingConnection || isConnected
                      ? Icon(Icons.check, size: 15, color: Colors.white)
                      : Icon(Icons.add,
                          size: 15, color: Theme.of(context).primaryColor),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (isPackMember) {
              // leave pack
              showDialog(
                context: buildContext,
                builder: (BuildContext context) => ConfirmDialog(
                  buildContext: buildContext,
                  confirmationText: 'Are you sure you want to leave this pack?',
                  confirm: leavePack,
                ),
              );
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
                      hasPendingPackRequest && !isPackMember
                          ? 'INVITED TO PACK'
                          : 'IN PACK',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor,
                        decoration: TextDecoration.none,
                        letterSpacing: 1.2,
                      ),
                    ),
                    hasPendingPackRequest && !isPackMember
                        ? Container(
                            margin: const EdgeInsets.only(top: 2.5),
                            child: Text(
                              'PENDING',
                              style: Theme.of(context).textTheme.overline,
                            ),
                          )
                        : const SizedBox()
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).backgroundColor, width: 1.2),
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
                  child: Icon(Icons.check, size: 15, color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
