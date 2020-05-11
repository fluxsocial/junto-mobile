import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/hive_keys.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/welcome/bloc/auth_bloc.dart';
import 'package:junto_beta_mobile/screens/welcome/bloc/auth_event.dart';
import 'package:junto_beta_mobile/screens/welcome/reset_password_confirm.dart';
import 'package:junto_beta_mobile/screens/welcome/reset_password_request.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_in.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_about.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_photos.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_register.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_themes.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_verify.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_welcome.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:provider/provider.dart';

import 'widgets/sign_up_arrows.dart';
import 'widgets/sign_up_text_field_wrapper.dart';
import 'widgets/welcome_background.dart';
import 'widgets/welcome_main.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key key}) : super(key: key);

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
  // Used when resetting password
  final ValueNotifier<String> _email = ValueNotifier("");
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

  UserRepo userRepository;
  UserDataProvider userDataProvider;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    //TODO: don't perform user signup in state of welcome.dart
    userRepository = Provider.of<UserRepo>(context, listen: false);
    userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
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
      context.bloc<AuthBloc>().add(SignUpEvent(details));
      _userAddress = userDataProvider.userAddress;
      JuntoLoader.hide();
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
        await userRepository.updateUser(
          profilePictures[0] == null ? _photoKeys : _profilePictureKeys,
          _userAddress,
        );
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

  void _userNameSubmission() async {
    bool _correctLength = username.length >= 1 && username.length <= 22;
    final exp = RegExp("^[a-z0-9_]+\$");
    if (username != null && exp.hasMatch(username) && _correctLength) {
      await _nextSignUpPage();
    } else {
      FocusScope.of(context).unfocus();
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: S.of(context).welcome_username_requirements,
        ),
      );
    }
  }

  void _nameCheck() async {
    bool _correctLength = name.length >= 1 && name.length <= 50;
    if (name != null && name.isNotEmpty && _correctLength) {
      await _nextSignUpPage();
    } else {
      FocusScope.of(context).unfocus();
      return;
    }
  }

  bool _passwordCheck(String password) {
    final String passwordRegEx =
        "(?=.{8,})(?=.*[!@#\$%^&*])(?=.*[0-9])(?=.*[A-Z])(?=.*[A-z])";
    final exp = RegExp(passwordRegEx);
    bool match = exp.hasMatch(password);
    if (!match) {
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: S.of(context).welcome_password_rules,
        ),
      );
      return false;
    } else {
      return true;
    }
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
          // setting this to true causes white background to be shown during keyboard opening
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
                        PageKeepAlive(
                          child: SignIn(_signInController),
                        ),
                        ResetPasswordRequest(
                            signInController: _signInController, email: _email),
                        ValueListenableBuilder<String>(
                            valueListenable: _email,
                            builder: (context, email, _) {
                              return ResetPasswordConfirm(
                                signInController: _signInController,
                                email: email,
                              );
                            }),
                      ],
                    ),
                  ),
                  PageKeepAlive(
                    // 1
                    child: SignUpTextFieldWrapper(
                      textInputActionType: TextInputAction.done,
                      onValueChanged: (String value) => name = value,
                      onSubmit: _nameCheck,
                      maxLength: 50,
                      hint: S.of(context).welcome_my_name_is,
                      label: S.of(context).welcome_name_label,
                      title: S.of(context).welcome_name_hint,
                      textCapitalization: TextCapitalization.words,
                    ),
                  ),
                  PageKeepAlive(
                    // 2
                    child: SignUpTextFieldWrapper(
                      textInputActionType: TextInputAction.done,
                      onValueChanged: (String value) {
                        username = value.toLowerCase().trim();
                      },
                      onSubmit: _userNameSubmission,
                      maxLength: 22,
                      hint: S.of(context).welcome_username_ill_go,
                      label: S.of(context).welcome_username_label,
                      title: S.of(context).welcome_username_hint,
                      textCapitalization: TextCapitalization.none,
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
                  onTap: _nextSignUpPage,
                ),
              if (_currentIndex != 0)
                Positioned(
                  top: MediaQuery.of(context).size.height * .08,
                  left: 20,
                  child: Image.asset(
                    'assets/images/junto-mobile__logo.png',
                    height: 38,
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
        // ensure username is not empty
        if (username.isEmpty) {
          return;
        }
        // instantiate correct length and validation for username
        bool _correctLength = username.length >= 1 && username.length <= 22;
        final exp = RegExp("^[a-z0-9_]+\$");
        // ensure username is not null and username meets validation and length
        if (username == null || !exp.hasMatch(username) || !_correctLength) {
          showDialog(
            context: context,
            builder: (BuildContext context) => SingleActionDialog(
              dialogText: S.of(context).welcome_username_requirements,
            ),
          );
          return;
        } else {
          JuntoLoader.showLoader(context, color: Colors.transparent);
          // ensure username is not taken or reserved
          final Map<String, dynamic> validateUserResponse =
              await Provider.of<AuthRepo>(context, listen: false)
                  .validateUser(username: username);
          JuntoLoader.hide();
          final bool usernameIsAvailable =
              validateUserResponse['valid_username'];
          if (!usernameIsAvailable) {
            showDialog(
              context: context,
              builder: (BuildContext context) => SingleActionDialog(
                dialogText: S.of(context).welcome_username_taken,
              ),
            );
            return;
          }
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

        if (!_passwordCheck(password)) {
          return;
        }
        JuntoLoader.showLoader(context, color: Colors.transparent);
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
      if (error.message == 'follow the white rabbit') {
        // transition to next page of sign up flow
        _welcomeController.nextPage(
          curve: Curves.decelerate,
          duration: const Duration(milliseconds: 600),
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => SingleActionDialog(
            dialogText: S.of(context).welcome_username_taken,
          ),
        );
      }
    }
  }

  // ensure passwords are same and meet our specifications
  bool _validatePasswords(String password, String confirmPassword) {
    // ensure that passwords match
    if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: S.of(context).welcome_passwords_must_match,
        ),
      );
      return false;
    } else if (password.length < 8 || confirmPassword.length < 8) {
      // ensure that passwords are greater than 8 characters
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: S.of(context).welcome_password_length(8),
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
    final box = await Hive.openLazyBox(HiveBoxes.kAppBox, encryptionKey: key);
    final _theme = await box.get("current-theme") as String;

    setState(() {
      if (_theme == null) {
        _currentTheme = 'rainbow';
      } else {
        _currentTheme = _theme;
      }
    });

    final bool nightMode = await box.get('night-mode');
    if (nightMode == null) {
      await box.put('night-mode', false);
    }
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
