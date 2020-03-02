import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_in.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_about.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_name.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_photos.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_register.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_themes.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_username.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_verify.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_welcome.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'widgets/welcome_background.dart';

class Welcome extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext context) => Welcome(),
    );
  }

  @override
  State<StatefulWidget> createState() {
    return WelcomeState();
  }
}

class WelcomeState extends State<Welcome> {
  String _currentTheme;
  String _userAddress;

  PageController _welcomeController;
  PageController _signInController;

  int _currentIndex;
  String name;
  String username;
  String bio;
  String location;
  String gender;
  String website;
  List<dynamic> profilePictures;
  String email;
  String password;
  String confirmPassword;
  int verificationCode;

  String imageOne = '';
  String imageTwo = '';
  String imageThree = '';

  GlobalKey<SignUpAboutState> signUpAboutKey;
  GlobalKey<SignUpPhotosState> signUpPhotosKey;
  GlobalKey<SignUpRegisterState> signUpRegisterKey;
  GlobalKey<SignUpVerifyState> signUpVerifyKey;

  void _toggleTheme(String theme) {
    setState(() {
      _currentTheme = theme;
    });
  }

  Future<void> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String theme = prefs.getString('current-theme');

    setState(() {
      if (theme == null) {
        _currentTheme = 'rainbow';
      } else {
        _currentTheme = theme;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getTheme();

    signUpAboutKey = GlobalKey<SignUpAboutState>();
    signUpPhotosKey = GlobalKey<SignUpPhotosState>();
    signUpRegisterKey = GlobalKey<SignUpRegisterState>();
    signUpVerifyKey = GlobalKey<SignUpVerifyState>();

    _currentIndex = 0;
    _welcomeController = PageController(keepPage: true);
    _signInController = PageController(keepPage: true);
  }

  Future<void> _nextSignUpPage() async {
    try {
      if (_currentIndex == 4) {
        final AboutPageModel _aboutPageModel =
            signUpAboutKey.currentState.returnDetails();
        bio = _aboutPageModel.bio;
        location = _aboutPageModel.location;
        gender = _aboutPageModel.gender;
        website = _aboutPageModel.website;
      } else if (_currentIndex == 5) {
        profilePictures = signUpPhotosKey.currentState.returnDetails();
        print(profilePictures);
      } else if (_currentIndex == 6) {
        email = signUpRegisterKey.currentState.returnDetails()['email'];
        password = signUpRegisterKey.currentState.returnDetails()['password'];
        confirmPassword =
            signUpRegisterKey.currentState.returnDetails()['confirmPassword'];
        await Provider.of<AuthRepo>(context, listen: false).verifyEmail(email);
      }
      // transition to next page of sign up flow
      _welcomeController.nextPage(
        curve: Curves.easeIn,
        duration: const Duration(milliseconds: 400),
      );
    } on JuntoException catch (error) {
      JuntoDialog.showJuntoDialog(
        context,
        error.message,
        <Widget>[DialogBack()],
      );
    }
  }

  Future<void> _handleSignUp() async {
    setState(() {
      verificationCode = signUpVerifyKey.currentState.returnDetails();
    });

    final UserAuthRegistrationDetails details = UserAuthRegistrationDetails(
      email: email,
      name: name,
      password: password,
      location: <String>[location],
      username: username,
      profileImage: <String>[],
      website: <String>[website],
      gender: <String>[gender],
      verificationCode: verificationCode,
      bio: bio,
    );

    try {
      JuntoLoader.showLoader(context);

      // create user account
      final UserData results =
          await Provider.of<AuthRepo>(context, listen: false)
              .registerUser(details);
      print('ok');
      final Map<String, dynamic> resultsMap = results.toMap();
      final String resultsMapToString = json.encode(resultsMap);

      // save user to shared prefs
      await SharedPreferences.getInstance()
        ..setBool(
          'isLoggedIn',
          true,
        )
        ..setString('user_id', results.user.address)
        ..setString('user_data', resultsMapToString);
      setState(() {
        _userAddress = results.user.address;
      });
    } catch (error) {
      _welcomeController.jumpToPage(0);
      JuntoLoader.hide();
      print(error);
      print('Error: $error');
    }

    // Update user with profile photos
    if (profilePictures[0] != null) {
      // instantiate list to store photo keys retrieve from /s3
      final List<String> _photoKeys = <String>[];
      for (final dynamic image in profilePictures) {
        if (image != null) {
          try {
            final String key =
                await Provider.of<ExpressionRepo>(context, listen: false)
                    .createPhoto(
              false,
              '.png',
              image,
            );
            _photoKeys.add(key);
          } catch (error) {
            print(error);
            JuntoLoader.hide();
          }
        }
      }

      Map<String, dynamic> _profilePictureKeys;

      // instantiate data structure to update user with profile pictures
      _profilePictureKeys = <String, dynamic>{
        'profile_picture': <Map<String, dynamic>>[
          <String, dynamic>{'index': 0, 'key': _photoKeys[0]},
          if (_photoKeys.length == 2)
            <String, dynamic>{'index': 1, 'key': _photoKeys[1]},
        ]
      };
      // update user with profile photos
      try {
        await Provider.of<UserRepo>(context, listen: false).updateUser(
            profilePictures[0] == null ? _photoKeys : _profilePictureKeys,
            _userAddress);
      } catch (error) {
        print(error);
        JuntoLoader.hide();
      }
    }

    JuntoLoader.hide();
    // Navigate to community agreements
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<dynamic>(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return SignUpAgreements();
        },
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        transitionDuration: const Duration(
          milliseconds: 400,
        ),
      ),
    );
  }

  Future<bool> _animateOnBackPress() async {
    if (_currentIndex >= 1) {
      print(_currentIndex);
      _welcomeController.animateToPage(
        _currentIndex - 1,
        duration: kThemeAnimationDuration,
        curve: Curves.decelerate,
      );
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _animateOnBackPress,
      child: Scaffold(
        // setting this to true casues white background to be shown during keyboard opening
        resizeToAvoidBottomInset: false,
        body: Stack(children: <Widget>[
          WelcomeBackground(currentTheme: _currentTheme),
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
              PageKeepAlive(
                child: PageView(
                  controller: _signInController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    PageKeepAlive(child: _welcomeMain(context)),
                    PageKeepAlive(child: SignIn(_signInController))
                  ],
                ),
              ),
              PageKeepAlive(
                child: SignUpName(
                  onNamePressed: (String value) => name = value,
                ),
              ),
              PageKeepAlive(
                child: SignUpUsername(
                  onUsernameChange: (String value) => username = value,
                ),
              ),
              PageKeepAlive(
                child: SignUpThemes(toggleTheme: _toggleTheme),
              ),
              PageKeepAlive(
                child: SignUpAbout(key: signUpAboutKey),
              ),
              PageKeepAlive(
                child: SignUpPhotos(key: signUpPhotosKey),
              ),
              PageKeepAlive(
                child: SignUpRegister(key: signUpRegisterKey),
              ),
              PageKeepAlive(
                child: SignUpVerify(
                    key: signUpVerifyKey, handleSignUp: _handleSignUp),
              )
            ],
          ),
          _currentIndex != 0 && MediaQuery.of(context).viewInsets.bottom == 0
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
                      _currentIndex == 7
                          ? const SizedBox()
                          : GestureDetector(
                              onTap: () {
                                _nextSignUpPage();
                              },
                              child: Container(
                                height: 36,
                                width: 36,
                                color: Colors.transparent,
                                child: const Icon(Icons.keyboard_arrow_down,
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
      ),
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
                    Future<void>.delayed(const Duration(milliseconds: 400), () {
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
                        color: Theme.of(context).accentColor,
                        borderRadius: BorderRadius.circular(1000),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: const Color(0xff222222).withOpacity(.2),
                              offset: const Offset(0.0, 5.0),
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

class PageKeepAlive extends StatefulWidget {
  const PageKeepAlive({
    Key key,
    @required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _PageKeepAliveState createState() => _PageKeepAliveState();
}

class _PageKeepAliveState extends State<PageKeepAlive>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
