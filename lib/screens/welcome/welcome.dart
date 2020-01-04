import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_in.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_name.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_username.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_themes.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_about.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_photos.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_register.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_verify.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Welcome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomeState();
  }
}

class WelcomeState extends State<Welcome> {
  PageController _welcomeController;
  PageController _signInController;

  int _currentIndex;
  String name;
  String username;
  String bio;
  String location;
  String gender;
  String website;
  List<File> profilePictures;
  String email;
  String password;
  String confirmPassword;
  int verificationCode;

  GlobalKey<SignUpNameState> signUpNameKey;
  GlobalKey<SignUpUsernameState> signUpUsernameKey;
  GlobalKey<SignUpAboutState> signUpAboutKey;
  GlobalKey<SignUpPhotosState> signUpPhotosKey;
  GlobalKey<SignUpRegisterState> signUpRegisterKey;
  GlobalKey<SignUpVerifyState> signUpVerifyKey;

  @override
  void initState() {
    super.initState();
    signUpNameKey = GlobalKey<SignUpNameState>();
    signUpUsernameKey = GlobalKey<SignUpUsernameState>();
    signUpAboutKey = GlobalKey<SignUpAboutState>();
    signUpPhotosKey = GlobalKey<SignUpPhotosState>();
    signUpRegisterKey = GlobalKey<SignUpRegisterState>();
    signUpVerifyKey = GlobalKey<SignUpVerifyState>();

    _currentIndex = 0;
    _welcomeController = PageController();
    _signInController = PageController();
  }

  void _nextSignUpPage() {
    if (_currentIndex == 1) {
      setState(() {
        name = signUpNameKey.currentState.returnDetails();
      });
      if (name == '') {
        return;
      }
    } else if (_currentIndex == 2) {
      setState(() {
        username = signUpUsernameKey.currentState.returnDetails();
      });
      print(username);
      if (username == '') {
        return;
      }
    } else if (_currentIndex == 4) {
      setState(() {
        bio = signUpAboutKey.currentState.returnDetails()['bio'];
        location = signUpAboutKey.currentState.returnDetails()['location'];
        gender = signUpAboutKey.currentState.returnDetails()['gender'];
        website = signUpAboutKey.currentState.returnDetails()['website'];
      });
    } else if (_currentIndex == 5) {
      setState(() {
        profilePictures = signUpPhotosKey.currentState.returnDetails();
      });
    } else if (_currentIndex == 6) {
      final validation = signUpRegisterKey.currentState.validateRegistration();
      setState(() {
        email = signUpRegisterKey.currentState.returnDetails()['email'];
        password = signUpRegisterKey.currentState.returnDetails()['password'];
        confirmPassword =
            signUpRegisterKey.currentState.returnDetails()['confirmPassword'];
      });
    }

    // transition to next page of sign up flow
    _welcomeController.nextPage(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 400),
    );
  }

  Future<void> _handleSignUp() async {
    setState(() {
      verificationCode = signUpVerifyKey.currentState.returnDetails();
    });
    final UserAuthRegistrationDetails details = UserAuthRegistrationDetails(
      email: email,
      name: name,
      password: password,
      bio: bio,
      location: [location],
      username: username,
      profileImage: ['assets/images/junto-mobile__placeholder--member.png'],
      website: [website],
      gender: [gender],
      verificationCode: verificationCode,
    );
    try {
      final UserData results =
          await Provider.of<AuthRepo>(context).registerUser(details);
      final Map resultsMap = results.toMap();
      final String resultsMapToString = json.encode(resultsMap);

      await SharedPreferences.getInstance()
        ..setBool(
          'isLoggedIn',
          true,
        )
        ..setString('user_id', results.user.address)
        ..setString('user_data', resultsMapToString);

      Navigator.of(context).pushAndRemoveUntil(
        JuntoCollective.route(),
        (Route<dynamic> route) => false,
      );
    } on JuntoException catch (error) {
      JuntoDialog.showJuntoDialog(context, error.message, [
        FlatButton(
          child: Text('OK'),
        ),
      ]);
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: const <double>[0.3, 0.9],
              colors: <Color>[
                Theme.of(context).colorScheme.secondaryVariant,
                Theme.of(context).colorScheme.primaryVariant
              ],
            ),
          ),
        ),
        PageView(
            onPageChanged: (int int) {
              setState(() {
                _currentIndex = int;
              });
              print(_currentIndex);
            },
            controller: _welcomeController,
            scrollDirection: Axis.vertical,
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              PageView(
                controller: _signInController,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  _welcomeMain(context),
                  SignIn(_signInController)
                ],
              ),
              SignUpName(key: signUpNameKey),
              SignUpUsername(key: signUpUsernameKey),
              SignUpThemes(),
              SignUpAbout(key: signUpAboutKey),
              SignUpPhotos(key: signUpPhotosKey),
              SignUpRegister(key: signUpRegisterKey),
              SignUpVerify(key: signUpVerifyKey, handleSignUp: _handleSignUp)
            ]),
        _currentIndex != 0
            ? Positioned(
                bottom: MediaQuery.of(context).size.height * .05,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      child: GestureDetector(
                        onTap: () {
                          _welcomeController.previousPage(
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 400),
                          );
                        },
                        child: Container(
                          height: 36,
                          width: 36,
                          color: Colors.transparent,
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            color: Colors.white30,
                            size: 36,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        _nextSignUpPage();
                      },
                      child: Container(
                        height: 36,
                        width: 36,
                        color: Colors.transparent,
                        child: Icon(Icons.keyboard_arrow_down,
                            color: Colors.white, size: 36),
                      ),
                    ),
                  ],
                ),
              )
            : const SizedBox(),
        _currentIndex != 0
            ? Positioned(
                top: MediaQuery.of(context).size.height * .08,
                left: 20,
                child: Image.asset(
                    'assets/images/junto-mobile__logo--white.png',
                    height: 45),
              )
            : const SizedBox(),
      ]),
    );
  }

  Widget _welcomeMain(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 120, bottom: 30),
              child: Image.asset(
                'assets/images/junto-mobile__logo--white.png',
                height: 69,
              ),
            ),
            Container(
              child: const Text(
                'JUNTO',
                style: TextStyle(
                  letterSpacing: 3.6,
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ]),
          Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  onTap: () {
                    _welcomeController.nextPage(
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 400),
                    );
                    Future.delayed(const Duration(milliseconds: 400), () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                      vertical: 20,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryVariant,
                        borderRadius: BorderRadius.circular(1000),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(.12),
                              offset: const Offset(0.0, 6.0),
                              blurRadius: 9),
                        ]),
                    child: const Text(
                      'WELCOME TO THE PACK',
                      style: TextStyle(
                          letterSpacing: 1.2,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 120),
                child: GestureDetector(
                  onTap: () {
                    _signInController.nextPage(
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 300),
                    );
                  },
                  child: const Text(
                    'SIGN IN',
                    style: TextStyle(
                        letterSpacing: 1.2,
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
