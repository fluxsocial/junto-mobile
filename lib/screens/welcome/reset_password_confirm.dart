import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/models/auth_result.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_in_back_nav.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/buttons/call_to_action.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/dialogs/user_feedback.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:provider/provider.dart';

import 'widgets/resend_verification_code_button.dart';

class ResetPasswordConfirm extends StatefulWidget {
  const ResetPasswordConfirm({
    @required this.signInController,
    @required this.username,
  }) : assert(username != null || username != "");

  final PageController signInController;
  final String username;

  @override
  _ResetPasswordConfirmState createState() => _ResetPasswordConfirmState();
}

class _ResetPasswordConfirmState extends State<ResetPasswordConfirm> {
  TextEditingController _verificationCode;
  TextEditingController _newPassword;
  TextEditingController _confirmPassword;

  FocusNode _codeNode;
  FocusNode _passwordNode;
  FocusNode _confirmNode;

  @override
  void initState() {
    _verificationCode = TextEditingController();
    _newPassword = TextEditingController();
    _confirmPassword = TextEditingController();
    _codeNode = FocusNode();
    _passwordNode = FocusNode();
    _confirmNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _verificationCode.dispose();
    _newPassword.dispose();
    _confirmPassword.dispose();
    _codeNode.dispose();
    _passwordNode.dispose();
    _confirmNode.dispose();
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
          dialogText: "Passwords must match.",
        ),
      );
      return false;
    }
    return _passwordCheck(_newPassword.value.text);
  }

  Future<void> _confirmNewPassword() async {
    if (await _validatePasswords()) {
      try {
        JuntoLoader.showLoader(context);
        final result =
            await Provider.of<AuthRepo>(context, listen: false).resetPassword(
          ResetPasswordData(
            widget.username,
            _newPassword.text,
            _verificationCode.text,
          ),
        );
        JuntoLoader.hide();
        if (result.wasSuccessful) {
          await showFeedback(
            context,
            message: "Password successfully reset!",
          );
          await widget.signInController.animateToPage(
            1,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } else if (result.error != null) {
          _handlePasswordResetError(result);
        }
      } catch (error) {
        JuntoLoader.hide();
        logger.logError(error.message);
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
            dialogText:
                'We cannot reset your password now, please try again later',
          ),
        );
      }
    }
  }

  void _handlePasswordResetError(ResetPasswordResult result) {
    var message = '';
    switch (result.error) {
      case ResetPasswordError.InvalidCode:
        message = 'Invalid verification code';
        break;
      case ResetPasswordError.TooManyAttempts:
        message = 'Attempt limit exceeded, please try again later.';
        break;
      case ResetPasswordError.Unknown:
        message = 'We cannot reset your password now, please try again later';
        break;
    }
    showFeedback(context, message: message);
  }

  Future<void> _resendVerificationCode() async {
    assert(widget.username != null);
    try {
      final result = await Provider.of<AuthRepo>(context, listen: false)
          .resendVerificationCode(widget.username);
      if (result.wasSuccessful) {
        await showFeedback(context, message: "Confirmation code sent again!");
      } else {
        _handlePasswordResetError(result);
      }
    } catch (error) {
      logger.logDebug("Unable to send confirmation code $error");
      await showFeedback(context, message: "Confirmation code not sent!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SignInBackNav(signInController: widget.signInController),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flexible(
              flex: 3,
              child: KeyboardAvoider(
                autoScroll: true,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    SignUpTextField(
                      focusNode: _codeNode,
                      valueController: _verificationCode,
                      hint: S.of(context).welcome_verification_code,
                      maxLength: 100,
                      textInputActionType: TextInputAction.next,
                      onSubmit: () {
                        _passwordNode.requestFocus();
                      },
                      keyboardType: TextInputType.number,
                      textCapitalization: TextCapitalization.none,
                    ),
                    SignUpTextField(
                      focusNode: _passwordNode,
                      valueController: _newPassword,
                      hint: S.of(context).new_password_hint,
                      maxLength: 100,
                      textInputActionType: TextInputAction.next,
                      onSubmit: () {
                        _confirmNode.requestFocus();
                      },
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      obscureText: true,
                    ),
                    SignUpTextField(
                      focusNode: _confirmNode,
                      valueController: _confirmPassword,
                      hint: S.of(context).welcome_confirm_password,
                      maxLength: 100,
                      textInputActionType: TextInputAction.done,
                      onSubmit: () {
                        FocusScope.of(context).unfocus();
                      },
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      obscureText: true,
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  CallToActionButton(
                    callToAction: _confirmNewPassword,
                    title: S.of(context).welcome_confirm_password.toUpperCase(),
                  ),
                  const SizedBox(height: 15),
                  ResendVerificationCodeButton(
                    onPressed: _resendVerificationCode,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
