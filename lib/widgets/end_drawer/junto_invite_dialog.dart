import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';

class JuntoInviteDialog extends StatefulWidget {
  const JuntoInviteDialog({this.buildContext});
  final BuildContext buildContext;

  @override
  State<StatefulWidget> createState() {
    return JuntoInviteDialogState();
  }
}

class JuntoInviteDialogState extends State<JuntoInviteDialog> {
  TextEditingController emailController;
  TextEditingController nameController;

  void inviteUser(BuildContext context, String email, String name) async {
    try {
      JuntoLoader.showLoader(context);
      final int statusCode = await Provider.of<UserRepo>(context, listen: false)
          .inviteUser(email, name);
      Navigator.pop(context);
      JuntoLoader.hide();

      String dialogText;
      if (statusCode == 200) {
        dialogText =
            'Your invitation is on its way! Feel free to invite another person to Junto in 7 days.';
      } else if (statusCode == 403) {
        dialogText =
            'You can only send one invitation per week. Please wait 7 days from the time you sent your last invitation.';
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
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    nameController.dispose();
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
              "You can invite one person a week to Junto - who would you like to bring on?",
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
              ),
              child: TextField(
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
            ),
            const SizedBox(height: 12.5),
            Container(
              margin: const EdgeInsets.only(
                bottom: 25,
              ),
              child: TextField(
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
