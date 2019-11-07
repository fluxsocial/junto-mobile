import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/sign_up/sign_up_logo/sign_up_logo.dart';
import 'package:junto_beta_mobile/screens/sign_up/sign_up_three/sign_up_three.dart';

class SignUpTwo extends StatefulWidget {
  const SignUpTwo({Key key, this.firstName, this.lastName, this.email})
      : super(key: key);

  final String firstName;
  final String lastName;
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
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: <double>[0.1, 0.9],
                colors: <Color>[
                  Color(0xff5E54D0),
                  Color(0xff307FAB),
                ],
              ),
            ),
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
                                  username = text;
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
                    usernameController.text = '';
                    if (widget.firstName != '' &&
                        widget.lastName != '' &&
                        username != '') {
                      Navigator.push(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => SignUpThree(
                            firstName: widget.firstName,
                            lastName: widget.lastName,
                            email: widget.email,
                            username: username,
                          ),
                        ),
                      );
                    }
                  },
                  child: Icon(
                    Icons.arrow_right,
                    color: Colors.white,
                    size: 22,
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
