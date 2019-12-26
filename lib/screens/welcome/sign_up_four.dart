import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_welcome.dart';

class SignUpFour extends StatefulWidget {
  const SignUpFour({
    Key key,
    this.name,
    this.username,
    this.password,
    this.email,
  }) : super(key: key);

  final String name;
  final String username;
  final String password;
  final String email;

  @override
  State<StatefulWidget> createState() {
    return SignUpFourState();
  }
}

class SignUpFourState extends State<SignUpFour> {
  static TextEditingController bioController = TextEditingController();
  String bio = '';
  String profilePicture = '';

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
                top: MediaQuery.of(context).size.height * .10 + 18,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        bottom: MediaQuery.of(context).size.height * .17),
                    child: const Text(
                      'We are almost done! Feel free to upload a photo and '
                      'write a brief bio of who you are',
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
                            controller: bioController,
                            onChanged: (String text) {
                              setState(
                                () {
                                  bio = text;
                                },
                              );
                            },
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              labelStyle: TextStyle(color: Colors.green),
                              hintText: 'A LITTLE BIT ABOUT MYSELF...',
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
        ],
      ),
    );
  }
}
