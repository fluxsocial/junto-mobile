import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_page_title.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';

class SignUpRegister extends StatefulWidget {
  const SignUpRegister({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignUpRegisterState();
  }
}

class SignUpRegisterState extends State<SignUpRegister> {
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;

  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();
  final String passwordRegEx =
      "(?=.{8,})(?=.*[!@#\$%^&*])(?=.*[0-9])(?=.*[A-Z])(?=.*[A-z])";

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    emailNode.dispose();
    passwordNode.dispose();
    confirmPasswordNode.dispose();
    super.dispose();
  }

  Map<String, dynamic> returnDetails() {
    return <String, dynamic>{
      'email': emailController.value.text,
      'password': passwordController.value.text,
      'confirmPassword': confirmPasswordController.value.text,
    };
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
      JuntoDialog.showJuntoDialog(
        context,
        'Passwords must contain at least 1 number, 8 characters, 1 special character, and one uppercase letter.',
        [DialogBack()],
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * .16),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SignUpPageTitle(title: 'Almost done!'),
            Expanded(
              child: KeyboardAvoider(
                autoScroll: true,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Column(
                    children: <Widget>[
                      SignUpTextField(
                        valueController: emailController,
                        textInputActionType: TextInputAction.next,
                        onSubmit: () {
                          FocusScope.of(context).requestFocus(passwordNode);
                        },
                        focusNode: emailNode,
                        hint: 'Email',
                        maxLength: 1000,
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 40),
                      SignUpTextField(
                        valueController: passwordController,
                        textInputActionType: TextInputAction.next,
                        onSubmit: () => _passwordCheck(
                            passwordController.value.text, confirmPasswordNode),
                        focusNode: passwordNode,
                        hint: 'Password',
                        maxLength: 1000,
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.emailAddress,
                        obscureText: true,
                      ),
                      const SizedBox(height: 40),
                      SignUpTextField(
                        valueController: confirmPasswordController,
                        textInputActionType: TextInputAction.done,
                        onSubmit: () => _passwordCheck(
                            confirmPasswordController.value.text, null),
                        focusNode: confirmPasswordNode,
                        hint: 'Confirm Password',
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
  }
}
