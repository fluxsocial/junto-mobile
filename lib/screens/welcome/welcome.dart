import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:junto_beta_mobile/api.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
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
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
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

  PageController _welcomeController;
  PageController _signInController;

  int _currentIndex;
  File profilePicture;

  GlobalKey<SignUpAboutState> signUpAboutKey;
  GlobalKey<SignUpPhotosState> signUpPhotosKey;
  GlobalKey<SignUpRegisterState> signUpRegisterKey;
  GlobalKey<SignUpVerifyState> signUpVerifyKey;

  UserRepo userRepository;
  UserDataProvider userDataProvider;
  AuthRepo authRepo;

  TextEditingController nameController;
  TextEditingController userNameController;
  TextEditingController locationController;
  TextEditingController pronounController;
  TextEditingController websiteController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController confirmPasswordController;
  TextEditingController verificationCodeController;

  @override
  void initState() {
    super.initState();
    _getTheme();

    signUpAboutKey = GlobalKey<SignUpAboutState>();
    signUpPhotosKey = GlobalKey<SignUpPhotosState>();
    signUpRegisterKey = GlobalKey<SignUpRegisterState>();
    signUpVerifyKey = GlobalKey<SignUpVerifyState>();

    nameController = TextEditingController();
    userNameController = TextEditingController();
    locationController = TextEditingController();
    pronounController = TextEditingController();
    websiteController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    verificationCodeController = TextEditingController();

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
    userRepository = Provider.of<UserRepo>(context, listen: false);
    userDataProvider = Provider.of<UserDataProvider>(context, listen: false);
    authRepo = Provider.of<AuthRepo>(context, listen: false);
  }

  @override
  void dispose() {
    _welcomeController.dispose();
    _signInController.dispose();
    nameController?.dispose();
    userNameController?.dispose();
    locationController?.dispose();
    pronounController?.dispose();
    websiteController?.dispose();
    emailController?.dispose();
    passwordController?.dispose();
    confirmPasswordController?.dispose();
    verificationCodeController?.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    setState(() {});
    final verificationCode = int.parse(verificationCodeController.text);

    final UserAuthRegistrationDetails details = UserAuthRegistrationDetails(
      email: emailController.text,
      name: nameController.text,
      username: userNameController.text,
      password: passwordController.text,
      confirmPassword: confirmPasswordController.text,
      location: <String>[locationController.text],
      profileImage: <String>[],
      backgroundPhoto: '',
      website: <String>[websiteController.text],
      gender: <String>[pronounController.text],
      verificationCode: verificationCode,
      bio: '',
    );

    context.bloc<AuthBloc>().add(SignUpEvent(details, profilePicture));
  }

  void _userNameSubmission() async {
    final username = userNameController.text.trim();
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
    final name = nameController.text.trim();
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
                  PageView(
                    controller: _signInController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: <Widget>[
                      WelcomeMain(
                        onSignIn: _onSignIn,
                        onSignUp: _onSignUp,
                      ),
                      SignIn(_signInController),
                      ResetPasswordRequest(
                        signInController: _signInController,
                        email: _email,
                      ),
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
                  SignUpTextFieldWrapper(
                    controller: nameController,
                    textInputActionType: TextInputAction.done,
                    onSubmit: _nameCheck,
                    maxLength: 50,
                    hint: S.of(context).welcome_my_name_is,
                    label: S.of(context).welcome_name_label,
                    title: S.of(context).welcome_name_hint,
                    textCapitalization: TextCapitalization.words,
                  ),
                  SignUpTextFieldWrapper(
                    controller: userNameController,
                    textInputActionType: TextInputAction.done,
                    onSubmit: _userNameSubmission,
                    maxLength: 22,
                    hint: S.of(context).welcome_username_ill_go,
                    label: S.of(context).welcome_username_label,
                    title: S.of(context).welcome_username_hint,
                    textCapitalization: TextCapitalization.none,
                  ),
                  SignUpThemes(toggleTheme: _toggleTheme),
                  SignUpAbout(
                    key: signUpAboutKey,
                    nextPage: _nextSignUpPage,
                    pronounController: pronounController,
                    locationController: locationController,
                    websiteController: websiteController,
                  ),
                  SignUpPhotos(key: signUpPhotosKey),
                  SignUpRegister(
                    key: signUpRegisterKey,
                    emailController: emailController,
                    passwordController: passwordController,
                    confirmPasswordController: confirmPasswordController,
                  ),
                  SignUpVerify(
                    key: signUpVerifyKey,
                    handleSignUp: _handleSignUp,
                    verificationController: verificationCodeController,
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
      final name = nameController.text.trim();
      final username = userNameController.text.trim();

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
              await authRepo.validateUser(username: username);
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
        //
      } else if (_currentIndex == 5) {
        profilePicture = signUpPhotosKey.currentState.returnDetails();
      } else if (_currentIndex == 6) {
        //
        final email = emailController.text.trim();
        final password = passwordController.text;
        final confirmPassword = confirmPasswordController.text;
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
        final result = await authRepo.verifyEmail(email);
        logger.logDebug(result);
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
            dialogText: error.message,
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
