import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/backend.dart';

import 'junto_invite_appbar.dart';
import 'junto_invite_cta.dart';
import 'junto_invite_logo.dart';

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
              vertical: 40,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    JuntoInviteLogo(),
                    JuntoInviteText(
                      "Junto was created from the desire to have more meaningful experiences on social media. On Junto, you can build your Pack - people closest to you that evoke the most unfiltered version of yourself.",
                    ),
                    JuntoInviteText(
                      "We envision the growth of Junto to take place through the creation of each individual's closest relationships and invite you to bring on one new person a week. Thank you for participating in building this grassroots community with us.",
                    ),
                  ],
                ),
                JuntoInviteCTA(
                  title: 'INVITE SOMEONE TO JUNTO',
                  callToAction: () {},
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
