import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_in_back_nav.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/widgets/buttons/call_to_action.dart';
import 'package:junto_beta_mobile/widgets/dialogs/user_feedback.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:provider/provider.dart';

class ResetPasswordRequest extends StatefulWidget {
  const ResetPasswordRequest({this.signInController});

  final PageController signInController;

  @override
  _ResetPasswordRequestState createState() => _ResetPasswordRequestState();
}

class _ResetPasswordRequestState extends State<ResetPasswordRequest> {
  TextEditingController _textEditingController;
  GlobalKey<FormState> _formKey;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _formKey = GlobalKey();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  /// Request a verification code from the server.
  Future<void> _requestEmail() async {
    if (_formKey.currentState.validate()) {
      try {
        final int responseStatusCode =
            await Provider.of<AuthRepo>(context, listen: false)
                .requestPasswordReset(
          _textEditingController.value.text,
        );

        // if 310, then continue as this status code represents that a verification
        // email has already been sent
        if (responseStatusCode == 310) {
          widget.signInController.nextPage(
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 300),
          );
        } else {
          await showFeedback(
            context,
            message: "Check your email for a verification code.",
          );
          widget.signInController.nextPage(
            curve: Curves.easeIn,
            duration: const Duration(milliseconds: 300),
          );
        }

        return;
      } on JuntoException catch (error) {
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
            dialogText: error.message,
          ),
        );
        return;
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SignUpTextField(
                      valueController: _textEditingController,
                      hint: S.of(context).welcome_email_hint,
                      maxLength: 100,
                      textInputActionType: TextInputAction.done,
                      onSubmit: () {
                        FocusScope.of(context).unfocus();
                      },
                      keyboardType: TextInputType.emailAddress,
                      textCapitalization: TextCapitalization.none,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 120),
              child: CallToActionButton(
                callToAction: _requestEmail,
                title: S.of(context).welcome_reset_password,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
