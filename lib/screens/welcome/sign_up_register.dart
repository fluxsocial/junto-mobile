import 'package:flutter/material.dart';

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
            Container(
              child: const Text(
                'Almost done!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            controller: emailController,
                            textInputAction: TextInputAction.done,
                            maxLines: null,
                            cursorColor: Colors.white70,
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                              fillColor: Colors.white,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            controller: passwordController,
                            cursorColor: Colors.white70,
                            textInputAction: TextInputAction.done,
                            obscureText: true,
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                              fillColor: Colors.white,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: TextField(
                            controller: confirmPasswordController,
                            cursorColor: Colors.white70,
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              hintText: 'Confirm password',
                              hintStyle: TextStyle(
                                color: Colors.white70,
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                              fillColor: Colors.white,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
