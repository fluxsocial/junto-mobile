import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_in_back_nav.dart';
import 'package:junto_beta_mobile/widgets/buttons/call_to_action.dart';

class ResetPasswordRequest extends StatelessWidget {
  const ResetPasswordRequest({this.signInController});

  final PageController signInController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SignInBackNav(signInController: signInController),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SignUpTextField(
                    hint: S.of(context).welcome_email_hint,
                    maxLength: 100,
                    textInputActionType: TextInputAction.next,
                    onSubmit: () {
                      FocusScope.of(context).nextFocus();
                    },
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 120),
              child: CallToActionButton(
                callToAction: () {
                  signInController.nextPage(
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 300),
                  );
                },
                title: S.of(context).welcome_reset_password,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
