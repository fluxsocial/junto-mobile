import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';

class JuntoInviteDialog extends StatefulWidget {
  const JuntoInviteDialog({
    this.buildContext,
    this.invitesMadeThisWeek,
  });
  final BuildContext buildContext;
  final int invitesMadeThisWeek;

  @override
  State<StatefulWidget> createState() {
    return JuntoInviteDialogState();
  }
}

class JuntoInviteDialogState extends State<JuntoInviteDialog> {
  int invitesLeft;
  String inviteText;
  TextEditingController nameController;
  TextEditingController emailController;

  void inviteUser(BuildContext context, String email, String name) async {
    try {
      JuntoLoader.showLoader(context);
      final int statusCode = await Provider.of<UserRepo>(context, listen: false)
          .inviteUser(email, name);
      Navigator.pop(context);
      JuntoLoader.hide();

      String dialogText;
      await getInviteInfo();
      if (statusCode == 200) {
        dialogText =
            'Your invitation is on its way! You have ${invitesLeft} ${inviteText} left this week.';
      } else if (statusCode == 403) {
        dialogText =
            'You can only send three invitations per week. Please wait until you can send more invites';
      }
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          context: context,
          dialogText: dialogText,
        ),
      );
    } catch (error) {
      Navigator.pop(context);
      JuntoLoader.hide();

      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          context: context,
          dialogText: error.message,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    nameController = TextEditingController();
    getInviteInfo();
  }

  Future<void> getInviteInfo() async {
    final Map<String, dynamic> inviteInfo =
        await Provider.of<UserRepo>(context, listen: false).lastInviteSent();
    final int invitesMadeThisWeek = inviteInfo['invites_made_this_week'];

    setState(() {
      invitesLeft = invitesMadeThisWeek == null ? 3 : 3 - invitesMadeThisWeek;
      inviteText = invitesLeft == 1 ? 'invite' : 'invites';
    });
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 25,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "You have ${invitesLeft} ${inviteText} left this week - who would you like to bring on?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 25,
                bottom: 25,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    buildCounter: (
                      BuildContext context, {
                      int currentLength,
                      int maxLength,
                      bool isFocused,
                    }) =>
                        null,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0.0),
                      hintText: 'Your Full Name',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                    cursorWidth: 1,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                    maxLength: 40,
                    textInputAction: TextInputAction.done,
                  ),
                  Text(
                    'Please provide your name so your friend knows who is inviting them.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                bottom: 12.5,
              ),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    buildCounter: (
                      BuildContext context, {
                      int currentLength,
                      int maxLength,
                      bool isFocused,
                    }) =>
                        null,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0.0),
                      hintText: 'Their Email',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    cursorColor: Theme.of(context).primaryColor,
                    cursorWidth: 1,
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                    maxLength: 40,
                    textInputAction: TextInputAction.done,
                  ),
                  Text(
                    'Please provide the email of the person receiving the invite.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 25),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                            right: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 1),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (emailController.text.trim().isNotEmpty &&
                            nameController.text.trim().isNotEmpty) {
                          inviteUser(
                            context,
                            emailController.text.trim(),
                            nameController.text.trim(),
                          );
                        }
                      },
                      child: Container(
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Text(
                          'INVITE',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
