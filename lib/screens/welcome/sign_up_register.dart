import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';

import 'package:provider/provider.dart';

class SignUpRegister extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  const SignUpRegister({
    Key key,
    this.emailController,
    this.passwordController,
    this.confirmPasswordController,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignUpRegisterState();
  }
}

class SignUpRegisterState extends State<SignUpRegister> {
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();
  final String passwordRegEx =
      "(?=.{8,})(?=.*[!@#\$%^&*])(?=.*[0-9])(?=.*[A-Z])(?=.*[A-z])";

  @override
  void dispose() {
    emailNode.dispose();
    passwordNode.dispose();
    confirmPasswordNode.dispose();
    super.dispose();
  }

  bool _passwordCheck(String password, FocusNode node) {
    final exp = RegExp(passwordRegEx);
    bool match = exp.hasMatch(password);
    if (match) {
      if (node != null) {
        FocusScope.of(context).requestFocus(node);
        return true;
      } else {
        FocusScope.of(context).unfocus();
        return false;
      }
    } else {
      if (widget.passwordController.text !=
          widget.confirmPasswordController.text) {
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
            dialogText: S.of(context).welcome_passwords_must_match,
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
            dialogText: S.of(context).welcome_password_rules,
          ),
        );
      }

      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: MediaQuery.of(context).size.height * .17),
              Text(
                'If you reserved your username beforehand, please use the email associated with your crowdfunding account.',
                style: TextStyle(
                  color:
                      JuntoPalette().juntoWhite(theme: theme).withOpacity(.70),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: KeyboardAvoider(
                  autoScroll: true,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Column(
                      children: <Widget>[
                        SignUpTextField(
                          valueController: widget.emailController,
                          textInputActionType: TextInputAction.next,
                          onSubmit: () {
                            FocusScope.of(context).requestFocus(passwordNode);
                          },
                          focusNode: emailNode,
                          hint: S.of(context).welcome_email_hint,
                          maxLength: 1000,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 40),
                        SignUpTextField(
                          valueController: widget.passwordController,
                          textInputActionType: TextInputAction.next,
                          onSubmit: () => _passwordCheck(
                              widget.passwordController.text,
                              confirmPasswordNode),
                          focusNode: passwordNode,
                          hint: S.of(context).welcome_password_hint,
                          maxLength: 1000,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: true,
                        ),
                        const SizedBox(height: 40),
                        SignUpTextField(
                          valueController: widget.confirmPasswordController,
                          textInputActionType: TextInputAction.done,
                          onSubmit: () => _passwordCheck(
                              widget.confirmPasswordController.text, null),
                          focusNode: confirmPasswordNode,
                          hint: S.of(context).welcome_confirm_password,
                          maxLength: 1000,
                          textCapitalization: TextCapitalization.none,
                          keyboardType: TextInputType.emailAddress,
                          obscureText: true,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
