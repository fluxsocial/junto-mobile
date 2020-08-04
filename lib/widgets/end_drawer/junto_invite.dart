import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/widgets/logos/junto_logo_outline.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';

import 'junto_invite_appbar.dart';
import 'junto_invite_cta.dart';
import 'junto_invite_dialog.dart';
import 'junto_invite_notice.dart';

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
                      final String timestamp =
                          await Provider.of<UserRepo>(context, listen: false)
                              .lastInviteSent();
                      print(timestamp);
                      final newTimestamp = DateTime.parse(timestamp);

                      final Duration timeSinceLastInvitation =
                          DateTime.now().difference(newTimestamp);
                      if (timeSinceLastInvitation.inHours == 1000 ||
                          timeSinceLastInvitation.inHours > 1000) {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) => JuntoInviteDialog(
                            buildContext: context,
                          ),
                        );
                      } else {
                        String timeUntilNextInvitation;
                        String timeToString;

                        if (timeSinceLastInvitation.inHours > 48) {
                          timeUntilNextInvitation =
                              timeSinceLastInvitation.inDays.toString();
                          timeToString = 'days';
                        } else if (timeSinceLastInvitation.inHours < 1) {
                          timeUntilNextInvitation =
                              timeSinceLastInvitation.inMinutes.toString();

                          timeToString = timeUntilNextInvitation == 1
                              ? 'minute'
                              : 'minutes';
                        } else if (timeSinceLastInvitation.inHours >= 1 ||
                            timeSinceLastInvitation.inHours <= 48) {
                          timeUntilNextInvitation =
                              timeSinceLastInvitation.inHours.toString();
                          timeToString =
                              timeUntilNextInvitation == 1 ? 'hour' : 'hours';
                        }

                        showDialog(
                          context: context,
                          builder: (BuildContext context) => SingleActionDialog(
                            context: context,
                            dialogText:
                                'You can only invite one person every 7 days. Please wait another ${timeUntilNextInvitation} ${timeToString}.',
                          ),
                        );
                      }
                    } catch (error) {
                      print(error);
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
