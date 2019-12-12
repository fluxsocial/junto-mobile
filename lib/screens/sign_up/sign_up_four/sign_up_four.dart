import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/sign_up/sign_up_logo/sign_up_logo.dart';
import 'package:junto_beta_mobile/screens/sign_up/sign_up_welcome/sign_up_welcome.dart';

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
            child: Image.asset(
                'assets/images/junto-mobile__background--lotus.png'),
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
                  onTap: () async {
                    bioController.text = '';
                    if (widget.name != '' &&
                        widget.username != '' &&
                        widget.password != '') {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<dynamic>(
                          builder: (BuildContext context) => SignUpWelcome(
                            name: widget.name,
                            username: widget.username,
                            password: widget.password,
                            bio: bio,
                            profilePicture: profilePicture,
                            email: widget.email,
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
