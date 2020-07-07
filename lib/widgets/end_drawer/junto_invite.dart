import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/backend/backend.dart';

import 'junto_invite_appbar.dart';

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
              vertical: 10,
            ),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      JuntoInviteText(
                        "Junto was created from the desire to have more meaningful experiences on social media. On Junto, you have the opportunity to build your Pack -- people closest to you that evoke the most unfiltered version of yourself.",
                      ),
                      JuntoInviteText(
                        "You always have the option to share privately to your Pack. The people in your Pack will also have access to your Pack feed, which displays the public content from everyone in it. You become the common thread between all the people you invite, facilitating a more organic way for them to discover one another through their mutual connection - you. ",
                      ),
                      JuntoInviteText(
                        "We envision the growth of Junto to take place through the creation of each individual's closest relationships. Thank you for participating in building this grassroots community with us.",
                      ),
                    ],
                  ),
                ),
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
