import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/sign_up/sign_up_logo/sign_up_logo.dart';
import 'package:junto_beta_mobile/screens/sign_up/sign_up_two/sign_up_two.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  TextEditingController nameController;
  TextEditingController emailController;

  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: Image.asset(
                'assets/images/junto-mobile__background--lotus.png'),
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
                      'Hey, great to have you here. What is your name?',
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
                          child: TextField(
                            controller: nameController,
                            onChanged: (String text) {
                              setState(
                                () {
                                  name = text;
                                },
                              );
                            },
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.green),
                              hintText: 'FULL NAME',
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
                        Container(
                          margin: const EdgeInsets.only(top: 24.0),
                          child: TextField(
                            controller: emailController,
                            onChanged: (String text) {
                              setState(
                                () {
                                  email = text;
                                },
                              );
                            },
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.green),
                              hintText: 'EMAIL',
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
                    nameController.text = '';
                    if (name != '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) =>
                              SignUpTwo(name: name, email: email),
                        ),
                      );
                    }
                  },
                  child: Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                    size: 27,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
