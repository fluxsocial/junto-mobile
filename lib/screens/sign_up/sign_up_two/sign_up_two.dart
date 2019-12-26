import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/sign_up/sign_up_logo/sign_up_logo.dart';
import 'package:junto_beta_mobile/screens/sign_up/sign_up_three/sign_up_three.dart';

class SignUpTwo extends StatefulWidget {
  const SignUpTwo({Key key, this.name, this.email}) : super(key: key);

  final String name;
  final String email;

  @override
  State<StatefulWidget> createState() => SignUpTwoState();
}

class SignUpTwoState extends State<SignUpTwo> {
  TextEditingController usernameController;
  String username = '';

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Container(
        margin:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * .10 + 18),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * .17,
              ),
              child: const Text(
                'What username would you like to reserve?',
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
                      controller: usernameController,
                      onChanged: (String text) {
                        setState(
                          () {
                            username = text.toLowerCase();
                          },
                        );
                      },
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        labelStyle: TextStyle(
                          color: Colors.green,
                        ),
                        hintText: 'USERNAME',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
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
    );
  }
}
