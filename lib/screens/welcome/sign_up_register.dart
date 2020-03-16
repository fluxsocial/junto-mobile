import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_page_title.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field.dart';
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
                        onSubmit: () {
                          FocusScope.of(context)
                              .requestFocus(confirmPasswordNode);
                        },
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
                        onSubmit: () {
                          FocusScope.of(context).unfocus();
                        },
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
