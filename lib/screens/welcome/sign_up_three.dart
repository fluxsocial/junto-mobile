import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_four.dart';

class SignUpThree extends StatefulWidget {
  const SignUpThree({Key key, this.name, this.username, this.email})
      : super(key: key);

  final String name;
  final String username;
  final String email;

  @override
  State<StatefulWidget> createState() {
    return SignUpThreeState();
  }
}

class SignUpThreeState extends State<SignUpThree> {
  static TextEditingController passwordController = TextEditingController();
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
                'assets/images/junto-mobile__background--lotus.png',
                fit: BoxFit.cover),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .10 + 18),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * .17,
                    ),
                    child: const Text(
                      'Create a password. Make sure it is secure!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 36),
                          child: TextField(
                            controller: passwordController,
                            onChanged: (String text) {
                              setState(
                                () {
                                  password = text;
                                },
                              );
                            },
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              labelStyle: TextStyle(
                                color: Colors.green,
                              ),
                              hintText: 'PASSWORD',
                              hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w400),
                              fillColor: Colors.white,
                            ),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
