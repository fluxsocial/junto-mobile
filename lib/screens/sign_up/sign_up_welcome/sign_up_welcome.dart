import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/providers/auth_provider/auth_provider.dart';
import 'package:junto_beta_mobile/screens/template/template.dart';
import 'package:junto_beta_mobile/typography/palette.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Welcome screen shown to the user following registration
class SignUpWelcome extends StatefulWidget {
  const SignUpWelcome({
    Key key,
    @required this.firstName,
    @required this.lastName,
    @required this.username,
    @required this.password,
    @required this.bio,
    @required this.profilePicture,
    @required this.email,
  }) : super(key: key);

  /// First Name of the user
  final String firstName;

  /// Last Name of the user
  final String lastName;

  /// Username chosen by the user
  final String username;

  /// Password entered by the user
  final String password;

  /// User's bio
  final String bio;

  /// Url for the user's profile picture
  final String profilePicture;

  /// User's email
  final String email;

  @override
  State<StatefulWidget> createState() => SignUpWelcomeState();
}

class SignUpWelcomeState extends State<SignUpWelcome> {
  /// Stores the user state as `loggedIn` then navigates them
  /// to [JuntoTemplate]
  Future<void> _handleSignUp() async {
    final UserAuthRegistrationDetails details = UserAuthRegistrationDetails(
      email: widget.email,
      firstName: widget.firstName,
      lastName: widget.lastName,
      password: widget.password,
      bio: widget.bio,
      profileImage: widget.profilePicture ?? '',
    );
    try {
      final String results = await Provider.of<AuthenticationProvider>(context)
          .registerUser(details);
      print(results);
      await SharedPreferences.getInstance()
        ..setBool(
          'isLoggedIn',
          true,
        )
        ..setString('user_token', results);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute<dynamic>(
          builder: (BuildContext context) => JuntoTemplate(),
        ),
      );
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Container(
          margin: EdgeInsets.only(
            top: MediaQuery.of(context).size.height * .15,
            bottom: MediaQuery.of(context).size.height * .15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 40),
                    child: Image.asset(
                      'assets/images/junto-mobile__outlinelogo--gradient.png',
                      height: 69,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .5,
                    margin: const EdgeInsets.only(bottom: 40),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffeeeeee),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * .10),
                    margin: const EdgeInsets.only(bottom: 40),
                    child: Text(
                      'Hey ' +
                          widget.firstName +
                          '! We are stoked to have you here.',
                      style: const TextStyle(
                          color: JuntoPalette.juntoGrey,
                          fontWeight: FontWeight.w700,
                          fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .5,
                    margin: const EdgeInsets.only(bottom: 40),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xffeeeeee),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * .10),
                    child: const Text(
                      'Junto is a community of individuals working together to'
                      ' inspire authenticity and meaningful collaboration.',
                      style: TextStyle(
                        color: JuntoPalette.juntoGrey,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: <double>[0.1, 0.9],
                    colors: <Color>[
                      Color(0xff5E54D0),
                      Color(0xff307FAB),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    100,
                  ),
                ),
                child: RaisedButton(
                  onPressed: _handleSignUp,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  color: Colors.transparent,
                  elevation: 0,
                  // shape: RoundedRectangleBorder(borderRadius: BorderRadius
                  // .circular(100),),
                  child: const Text(
                    'LET\'S GO!',
                    style: TextStyle(
                      // color: JuntoPalette.juntoBlue,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
