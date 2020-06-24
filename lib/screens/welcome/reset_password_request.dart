import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_in_back_nav.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/buttons/call_to_action.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/dialogs/user_feedback.dart';
import 'package:provider/provider.dart';

class ResetPasswordRequest extends StatefulWidget {
  const ResetPasswordRequest(
      {@required this.usernameController, this.signInController});

  final PageController signInController;
  final TextEditingController usernameController;

  @override
  _ResetPasswordRequestState createState() => _ResetPasswordRequestState();
}

class _ResetPasswordRequestState extends State<ResetPasswordRequest> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  /// Request a verification code from the server.
  Future<void> _requestEmail() async {
    if (widget.usernameController.text.isEmpty) {
      await showFeedback(
        context,
        message: "Please provide your username",
      );
    } else {
      try {
        JuntoLoader.showLoader(context);
        final username = widget.usernameController.text;
        final result = await Provider.of<AuthRepo>(context, listen: false)
            .requestPasswordReset(username);

        if (result.wasSuccessful) {
          JuntoLoader.hide();
          await showFeedback(
            context,
            message: "Check your email for a verification code",
          );
          await Future.delayed(Duration(milliseconds: 300));
          widget.signInController.nextPage(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 300),
          );
        }

        return;
      } on JuntoException catch (error) {
        JuntoLoader.hide();
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
            dialogText: error.message,
          ),
        );
        return;
      } catch (error) {
        logger.logDebug("Platform error $error");
        JuntoLoader.hide();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SignInBackNav(signInController: widget.signInController),
      ),
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
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
                    valueController: widget.usernameController,
                    hint: S.of(context).welcome_username_hint_sign_in,
                    maxLength: 100,
                    textInputActionType: TextInputAction.done,
                    onSubmit: () {
                      FocusScope.of(context).unfocus();
                    },
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 120),
              child: CallToActionButton(
                callToAction: _requestEmail,
                title: S.of(context).welcome_reset_password.toUpperCase(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
