import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/widgets/logos/junto_logo_outline.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/utils/date_parsing.dart';

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
                        "Junto was created from the desire to have more meaningful experiences on social media. On Junto, you can build your Pack - people closest to you that evoke the most unfiltered version of yourself.",
                      ),
                      JuntoInviteText(
                        "We envision the growth of Junto to take place through the creation of each individual's closest relationships. Thank you for participating in building this grassroots community with us.",
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

                      // If the user made more than three invites this week, send a notice
                      if (inviteInfo['invites_made_this_week'] >= 3) {
                        // Get date time of last invitation sent
                        final DateTime lastInviteSent =
                            DateTime.parse(inviteInfo['last_invite']);

                        // Get date time of next available invite
                        final DateTime nextAvailableInvite = lastInviteSent.add(
                          Duration(days: 7),
                        );

                        // Show user when they can send the next invite
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => SingleActionDialog(
                            context: context,
                            dialogText:
                                'You can only invite three people every week. Please wait until ${nextAvailableInvite.month}/${nextAvailableInvite.day}/${nextAvailableInvite.year} at ${nextAvailableInvite.hour}:${nextAvailableInvite.minute} ${nextAvailableInvite.timeZoneName}.',
                          ),
                        );
                        // If the user made less than 3 invites this week, let them invite more people
                      } else {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) => JuntoInviteDialog(
                            buildContext: context,
                          ),
                        );
                      }
                    } catch (error) {
                      print(error);
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => SingleActionDialog(
                          context: context,
                          dialogText: error,
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
