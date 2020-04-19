import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_in_back_nav.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field.dart';
import 'package:junto_beta_mobile/widgets/buttons/call_to_action.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:provider/provider.dart';

class ResetPasswordConfirm extends StatefulWidget {
  const ResetPasswordConfirm({this.signInController});

  final PageController signInController;

  @override
  _ResetPasswordConfirmState createState() => _ResetPasswordConfirmState();
}

class _ResetPasswordConfirmState extends State<ResetPasswordConfirm> {
  TextEditingController _verificationCode;
  TextEditingController _newPassword;
  TextEditingController _confirmPassword;

  @override
  void initState() {
    _verificationCode = TextEditingController();
    _newPassword = TextEditingController();
    _confirmPassword = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _verificationCode.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  bool _passwordCheck(String password) {
    final String passwordRegEx =
        "(?=.{8,})(?=.*[!@#\$%^&*])(?=.*[0-9])(?=.*[A-Z])(?=.*[A-z])";
    final exp = RegExp(passwordRegEx);
    bool match = exp.hasMatch(password);
    if (!match) {
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: S.of(context).welcome_password_rules,
        ),
      );
      return false;
    } else {
      return true;
    }
  }

  Future<bool> _validatePasswords() async {
    if (_newPassword.value.text != _confirmPassword.value.text) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: "Both Passwords do not match",
        ),
      );
      return false;
    }
    return _passwordCheck(_newPassword.value.text);
  }

  Future<void> _confirmNewPassword() async {
    if (await _validatePasswords()) {
      await Provider.of<AuthRepo>(context).resetPassword(
        {
          "password": _newPassword.value.text,
          "confirm_password": _confirmPassword.value.text,
          "verification_code": _verificationCode.value.text as int,
          //TODO(Nash): Pass email
          "email": "string"
        },
      );
      Navigator.of(context).pushReplacement(Welcome.route());
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
                children: <Widget>[
                  SignUpTextField(
                    valueController: _verificationCode,
                    hint: S.of(context).welcome_verification_code,
                    maxLength: 100,
                    textInputActionType: TextInputAction.next,
                    onSubmit: () {
                      FocusScope.of(context).nextFocus();
                    },
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                  ),
                  const SizedBox(height: 45),
                  SignUpTextField(
                    valueController: _newPassword,
                    hint: S.of(context).welcome_password_hint,
                    maxLength: 100,
                    textInputActionType: TextInputAction.next,
                    onSubmit: () {
                      FocusScope.of(context).nextFocus();
                    },
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                  ),
                  const SizedBox(height: 45),
                  SignUpTextField(
                    valueController: _confirmPassword,
                    hint: S.of(context).welcome_confirm_password,
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
                callToAction: _confirmNewPassword,
                title: S.of(context).welcome_password_confirm,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
