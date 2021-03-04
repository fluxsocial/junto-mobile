import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/widgets/logos/junto_logo_outline.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';

import 'junto_invite_appbar.dart';
import 'junto_invite_cta.dart';
import 'junto_invite_dialog.dart';

class JuntoInvite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: JuntoInviteAppBar(),
      ),
      body: Consumer<UserDataProvider>(
          builder: (BuildContext context, UserDataProvider user, Widget child) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      const SizedBox(height: 40),
                      JuntoLogoOutline(),
                      JuntoInviteText(
                        "We envision Junto to grow through the creation of each individual's closest relationships. Right now, you can invite three people per week.",
                      ),
                      JuntoInviteText(
                        "You can also support our open source development by copying the link in the top right and sharing our ongoing Indiegogo campaign! Those who contribute will get instant access to the private beta.",
                      ),
                    ],
                  ),
                ),
                JuntoInviteCTA(
                  title: 'INVITE SOMEONE TO JUNTO',
                  callToAction: () async {
                    try {
                      // Get the invite capacity of user
                      final Map<String, dynamic> inviteInfo =
                          await Provider.of<UserRepo>(context, listen: false)
                              .lastInviteSent();
                      print(inviteInfo);

                      DateTime nextInvite;
                      DateTime currentTime;

                      // Get date time of next invite
                      if (inviteInfo['next_invite'] != null) {
                        nextInvite =
                            await DateTime.parse(inviteInfo['next_invite']);

                        currentTime = await DateTime.now();
                      }

                      // Show the invite dialog if the next available invite is before the current time
                      if (inviteInfo['next_invite'] == null ||
                          nextInvite.isBefore(currentTime)) {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) => JuntoInviteDialog(
                            buildContext: context,
                          ),
                        );
                      } else {
                        // Get date time of next invite
                        final DateTime nextInvite =
                            DateTime.parse(inviteInfo['next_invite']);

                        showDialog(
                          context: context,
                          builder: (BuildContext context) => SingleActionDialog(
                            context: context,
                            dialogText:
                                "It looks like you've already invited someone in the past 24 hours. Please wait until ${nextInvite.month}/${nextInvite.day}/${nextInvite.year} at ${nextInvite.hour}:${nextInvite.minute} ${nextInvite.timeZoneName}.",
                          ),
                        );
                      }
                    } catch (error) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => SingleActionDialog(
                          context: context,
                          dialogText: error.toString(),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}

class JuntoInviteText extends StatelessWidget {
  const JuntoInviteText(this.text);

  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
