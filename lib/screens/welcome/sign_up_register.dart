import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_page_title.dart';

import 'widgets/sign_up_text_field.dart';

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
              child: ListView(
                children: <Widget>[
                  SignUpTextField(
                    valueController: emailController,
                    onSubmit: () {
                      FocusScope.of(context).nextFocus();
                    },
                    hint: 'Email',
                    maxLength: 1000,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 50),
                  SignUpTextField(
                    valueController: passwordController,
                    onSubmit: () {
                      FocusScope.of(context).nextFocus();
                    },
                    hint: 'Password',
                    maxLength: 1000,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                  ),
                  const SizedBox(height: 50),
                  SignUpTextField(
                    valueController: confirmPasswordController,
                    onSubmit: () {
                      FocusScope.of(context).unfocus();
                    },
                    hint: 'Confirm Password',
                    maxLength: 1000,
                    textCapitalization: TextCapitalization.none,
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
