import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Welcome screen shown to the user following registration
class SignUpWelcome extends StatefulWidget {
  const SignUpWelcome({
    Key key,
    @required this.name,
    @required this.username,
    @required this.password,
    @required this.bio,
    @required this.profilePicture,
    @required this.email,
  }) : super(key: key);

  // Full name of user
  final String name;

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
        name: widget.name,
        password: widget.password,
        bio: widget.bio,
        location: 'New York',
        username: widget.username,
        profileImage: widget.profilePicture ?? '');
    try {
      JuntoOverlay.showLoader(context);
      final UserData results =
          await Provider.of<AuthRepo>(context).registerUser(details);

      await SharedPreferences.getInstance()
        ..setBool(
          'isLoggedIn',
          true,
        )
        ..setString('user_id', results.user.address);
      JuntoOverlay.hide();
      Navigator.of(context).pushAndRemoveUntil(
        JuntoCollective.route(),
        (Route<dynamic> route) => false,
      );
    } on JuntoException catch (error) {
      JuntoOverlay.hide();
      JuntoDialog.showJuntoDialog(
        context,
        error.message,
        <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              Welcome.route(),
              (Route<dynamic> route) => false,
            ),
            child: const Text('OK'),
          ),
        ],
      );
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
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    child: Image.asset(
                      'assets/images/junto-mobile__outlinelogo--gradient.png',
                      height: 69,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .5,
                    margin: const EdgeInsets.only(bottom: 25),
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
                        horizontal: MediaQuery.of(context).size.width * .05),
                    margin: const EdgeInsets.only(bottom: 25),
                    child: Text(
                      'Junto Community Agreements',
                      style: const TextStyle(
                          color: Color(0xff333333),
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
                        horizontal: MediaQuery.of(context).size.width * .05),
                    child: Column(
                      children: <Widget>[
                        Text(
                          '1. Be aware of the impact your words and actions have. Embrace kindness and compassion when interacting with others.',
                          style: Theme.of(context).textTheme.caption,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '2. Accept everyone else\'s experience as valid, even if it doesn\'t look like yours',
                          style: Theme.of(context).textTheme.caption,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '3. Expresson yourself freely. Be real and hold space for authenticity.',
                          style: Theme.of(context).textTheme.caption,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                width: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    stops: <double>[0.1, 0.9],
                    colors: <Color>[
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.primary
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
                  child: const Text(
                    'Yus, this looks good',
                    style: TextStyle(
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
