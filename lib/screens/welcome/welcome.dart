import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_in.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_about.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_photos.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_register.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_themes.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_verify.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_welcome.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';

import 'widgets/sign_up_arrows.dart';
import 'widgets/sign_up_text_field_wrapper.dart';
import 'widgets/welcome_background.dart';
import 'widgets/welcome_main.dart';

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

  @override
  void initState() {
    super.initState();
    _getTheme();

    signUpAboutKey = GlobalKey<SignUpAboutState>();
    signUpPhotosKey = GlobalKey<SignUpPhotosState>();
    signUpRegisterKey = GlobalKey<SignUpRegisterState>();
    signUpVerifyKey = GlobalKey<SignUpVerifyState>();

    _currentIndex = 0;
    _welcomeController = PageController(
      keepPage: true,
      //0.99 forces it to build next page
      viewportFraction: 0.99,
    );
    _signInController = PageController(keepPage: true);
  }

  @override
  void dispose() {
    _welcomeController.dispose();
    _signInController.dispose();
    super.dispose();
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
      backgroundPhoto: '',
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
      JuntoLoader.hide();
      print(error);
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: error.message,
        ),
      );
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
      FadeRoute<void>(
        child: SignUpAgreements(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _animateOnBackPress,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (FocusScope.of(context).hasFocus) {
            FocusScope.of(context).unfocus();
          }
        },
        child: Scaffold(
          // setting this to true casues white background to be shown during keyboard opening
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: <Widget>[
              WelcomeBackground(currentTheme: _currentTheme),
              PageView(
                onPageChanged: onPageChanged,
                controller: _welcomeController,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  PageKeepAlive(
                    child: PageView(
                      controller: _signInController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        PageKeepAlive(
                          child: WelcomeMain(
                            onSignIn: _onSignIn,
                            onSignUp: _onSignUp,
                          ),
                        ),
                        PageKeepAlive(child: SignIn(_signInController))
                      ],
                    ),
                  ),
                  PageKeepAlive(
                    // 1
                    child: SignUpTextFieldWrapper(
                      textInputActionType: TextInputAction.done,
                      onValueChanged: (String value) => name = value,
                      onSubmit: () async {
                        if (name.isNotEmpty &&
                            name.length <= 50 &&
                            name != null) {
                          await _nextSignUpPage();
                        } else {
                          FocusScope.of(context).unfocus();
                        }
                      },
                      maxLength: 50,
                      hint: 'My name is...',
                      label: 'FULL NAME',
                      title: 'Hey, what\'s your name?',
                    ),
                  ),
                  PageKeepAlive(
                    // 2
                    child: SignUpTextFieldWrapper(
                      textInputActionType: TextInputAction.done,
                      onValueChanged: (String value) => username = value,
                      onSubmit: () async {
                        if (username.isNotEmpty &&
                            username.length <= 22 &&
                            username != null) {
                          await _nextSignUpPage();
                        } else {
                          FocusScope.of(context).unfocus();
                        }
                      },
                      maxLength: 22,
                      hint: 'I\'ll go by...',
                      label: 'USERNAME',
                      title: 'Choose a unique username',
                    ),
                  ),
                  PageKeepAlive(
                    // 3
                    child: SignUpThemes(toggleTheme: _toggleTheme),
                  ),
                  PageKeepAlive(
                    // 4
                    child: SignUpAbout(
                      key: signUpAboutKey,
                      nextPage: _nextSignUpPage,
                    ),
                  ),
                  PageKeepAlive(
                    // 5
                    child: SignUpPhotos(key: signUpPhotosKey),
                  ),
                  PageKeepAlive(
                    // 6
                    child: SignUpRegister(key: signUpRegisterKey),
                  ),
                  PageKeepAlive(
                    // 7
                    child: SignUpVerify(
                      key: signUpVerifyKey,
                      handleSignUp: _handleSignUp,
                    ),
                  )
                ],
              ),
              if (_currentIndex != 0 &&
                  MediaQuery.of(context).viewInsets.bottom == 0)
                SignUpArrows(
                  welcomeController: _welcomeController,
                  currentIndex: _currentIndex,
                  onTap: () {
                    _nextSignUpPage();
                  },
                ),
              if (_currentIndex != 0)
                Positioned(
                  top: MediaQuery.of(context).size.height * .08,
                  left: 20,
                  child: Image.asset(
                    'assets/images/junto-mobile__logo.png',
                    height: 45,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _nextSignUpPage() async {
    try {
      if (_currentIndex == 1) {
        if (name == null || name.isEmpty || name.length > 50) {
          return;
        }
      } else if (_currentIndex == 2) {
        if (username == null || username.isEmpty || username.length > 22) {
          return;
        }
      } else if (_currentIndex == 4) {
        final AboutPageModel _aboutPageModel =
            signUpAboutKey.currentState.returnDetails();
        bio = _aboutPageModel.bio;
        location = _aboutPageModel.location;
        gender = _aboutPageModel.gender;
        website = _aboutPageModel.website;
        print(bio.length);
      } else if (_currentIndex == 5) {
        profilePictures = signUpPhotosKey.currentState.returnDetails();
        print(profilePictures);
      } else if (_currentIndex == 6) {
        email = signUpRegisterKey.currentState.returnDetails()['email'];
        password = signUpRegisterKey.currentState.returnDetails()['password'];
        confirmPassword =
            signUpRegisterKey.currentState.returnDetails()['confirmPassword'];
        if (email == null ||
            email.isEmpty ||
            password.isEmpty ||
            confirmPassword.isEmpty) {
          return;
        }
        // validate passwords
        if (!_validatePasswords(password, confirmPassword)) {
          return;
        }
        JuntoLoader.showLoader(context);
        // verify email address
        await Provider.of<AuthRepo>(context, listen: false).verifyEmail(email);
        JuntoLoader.hide();
      }
      // transition to next page of sign up flow
      _welcomeController.nextPage(
        curve: Curves.decelerate,
        duration: const Duration(milliseconds: 600),
      );
    } on JuntoException catch (error) {
      JuntoLoader.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: error.message,
        ),
      );
    }
  }

  // ensure passwords are same and meet our specifications
  bool _validatePasswords(String password, String confirmPassword) {
    if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Both passwords must match.',
        ),
      );
      return false;
    } else if (password.length < 8 || confirmPassword.length < 8) {
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText: 'Your password must be greater than 8 characters.',
        ),
      );
      return false;
    } else {
      return true;
    }
  }

  void _toggleTheme(String theme) {
    setState(() {
      _currentTheme = theme;
    });
  }

  Future<void> _getTheme() async {
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

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    print(_currentIndex);
  }

  Future<bool> _animateOnBackPress() async {
    if (_currentIndex >= 1) {
      print(_currentIndex);
      _previousSignUpPage();
      return false;
    } else if (_signInController.page > 0) {
      _signInController.animateToPage(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
      );
      return false;
    }
    return true;
  }

  void _previousSignUpPage() {
    _welcomeController.animateToPage(
      _currentIndex - 1,
      duration: kThemeAnimationDuration,
      curve: Curves.decelerate,
    );
  }

  void _onSignUp() {
    _welcomeController.nextPage(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 400),
    );
    Future<void>.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        _currentIndex = 1;
      });
    });
  }

  void _onSignIn() {
    _signInController.nextPage(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
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
