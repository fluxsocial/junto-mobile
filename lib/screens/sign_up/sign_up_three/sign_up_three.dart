import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/sign_up/sign_up_four/sign_up_four.dart';
import 'package:junto_beta_mobile/screens/sign_up/sign_up_logo/sign_up_logo.dart';

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
          child:
              Image.asset('assets/images/junto-mobile__background--lotus.png',fit: BoxFit.cover),
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
          SignUpLogo(),
          Positioned(
            bottom: MediaQuery.of(context).size.height * .05,
            right: 20,
            child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 17),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_left,
                      color: Colors.white,
                      size: 27,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    passwordController.text = '';
                    if (widget.name != '' &&
                        widget.username != '' &&
                        password != '' &&
                        password.length > 4) {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => SignUpFour(
                              name: widget.name,
                              username: widget.username,
                              password: password,
                              email: widget.email),
                        ),
                      );
                    }
                  },
                  child: Icon(Icons.arrow_right, color: Colors.white, size: 22),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
