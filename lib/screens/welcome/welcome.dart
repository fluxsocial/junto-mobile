import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/models/auth_result.dart';
import 'package:junto_beta_mobile/screens/welcome/bloc/auth_bloc.dart';
import 'package:junto_beta_mobile/screens/welcome/bloc/auth_event.dart';
import 'package:junto_beta_mobile/screens/welcome/bloc/auth_state.dart';
import 'package:junto_beta_mobile/screens/welcome/reset_password_confirm.dart';
import 'package:junto_beta_mobile/screens/welcome/reset_password_request.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_in.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_about.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_photos.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_register.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_themes.dart';
import 'package:junto_beta_mobile/screens/welcome/sign_up_verify.dart';
import 'package:junto_beta_mobile/utils/form_validation.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/background/background_theme.dart';
import 'package:junto_beta_mobile/widgets/dialogs/confirm_dialog.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:provider/provider.dart';

import 'widgets/sign_up_arrows.dart';
import 'widgets/sign_up_text_field_wrapper.dart';
import 'widgets/welcome_main.dart';

class Welcome extends StatefulWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: "welcome"),
      builder: (context) => Welcome(),
    );
  }

  const Welcome({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WelcomeState();
  }
}

class ProfilePicture {
  final ValueNotifier<File> file = ValueNotifier<File>(null);
  final ValueNotifier<File> originalFile = ValueNotifier<File>(null);
}

class WelcomeState extends State<Welcome> {
  final ProfilePicture profilePicture = ProfilePicture();

  PageController _welcomeController;
  PageController _signInController;

  int _currentIndex;

  AuthRepo authRepo;
  UserRepo userRepo;

  TextEditingController nameController;
  TextEditingController usernameController;
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
    nameController = TextEditingController();
    usernameController = TextEditingController();
    locationController = TextEditingController();
    pronounController = TextEditingController();
    websiteController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    verificationCodeController = TextEditingController();

    _currentIndex = 0;
    _welcomeController = PageController(
      //0.99 forces it to build next page
      viewportFraction: 0.99,
    );
    _signInController = PageController();
  }

  @override
  void dispose() {
    _welcomeController.dispose();
    _signInController.dispose();
    nameController?.dispose();
    usernameController?.dispose();
    locationController?.dispose();
    pronounController?.dispose();
    websiteController?.dispose();
    emailController?.dispose();
    passwordController?.dispose();
    confirmPasswordController?.dispose();
    verificationCodeController?.dispose();
    super.dispose();
  }

  Future<void> _finishSignUp() async {
    final verificationCode = verificationCodeController.text.trim();
    final username = usernameController.text..toLowerCase().trim();
    final password = passwordController.text;
    final email = emailController.text.trim();
    final name = nameController.text.trim();
    final location = locationController.text.trim();
    final website = websiteController.text.trim();
    final gender = pronounController.text.trim();

    final canContinue = await authRepo.verifySignUp(username, verificationCode);

    if (canContinue) {
      final UserRegistrationDetails details = UserRegistrationDetails.initial(
          email, username, name, location, website, gender);

      context.bloc<AuthBloc>().add(
          SignUpEvent(details, profilePicture.file.value, username, password));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => ConfirmDialog(
          buildContext: context,
          confirm: () => authRepo.resendVerificationCode(
              username, email, passwordController.text),
          errorMessage: '',
          confirmationText:
              'Wrong verification code. Do you want us to send verification code again?',
        ),
      );
    }
  }

  void _onUsernameSubmitted() async {
    final username = usernameController.text.toLowerCase().trim();
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
    authRepo = Provider.of<AuthRepo>(context, listen: false);
    userRepo = Provider.of<UserRepo>(context, listen: false);
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return WillPopScope(
        onWillPop: _animateOnBackPress,
        child: BlocListener<AuthBloc, AuthState>(
          listener: _onBlocStateChange,
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
                  BackgroundTheme(),
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
                            onSignIn: _onSignInSelected,
                            onSignUp: _onSignUpSelected,
                          ),
                          SignIn(
                            _signInController,
                            usernameController,
                          ),
                          ResetPasswordRequest(
                            signInController: _signInController,
                            usernameController: usernameController,
                          ),
                          ResetPasswordConfirm(
                            signInController: _signInController,
                            username: usernameController.text,
                          ),
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
                        controller: usernameController,
                        textInputActionType: TextInputAction.done,
                        onSubmit: _onUsernameSubmitted,
                        maxLength: 22,
                        hint: S.of(context).welcome_username_ill_go,
                        label: S.of(context).welcome_username_label,
                        title: S.of(context).welcome_username_hint,
                        textCapitalization: TextCapitalization.none,
                      ),
                      SignUpThemes(),
                      SignUpAbout(
                        nextPage: _nextSignUpPage,
                        pronounController: pronounController,
                        locationController: locationController,
                        websiteController: websiteController,
                      ),
                      SignUpPhotos(profilePicture),
                      SignUpRegister(
                        emailController: emailController,
                        passwordController: passwordController,
                        confirmPasswordController: confirmPasswordController,
                      ),
                      SignUpVerify(
                        handleSignUp: _finishSignUp,
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
                        color: JuntoPalette().juntoWhite(theme: theme),
                      ),
                    ),
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthUnauthenticated &&
                          state.loading == true) {
                        return Container(
                          color:
                              Theme.of(context).backgroundColor.withOpacity(.8),
                          child: JuntoProgressIndicator(),
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _nextSignUpPage() async {
    try {
      final name = nameController.text.trim();
      final username = usernameController.text.toLowerCase().trim();

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

          final usernameAvailable = await userRepo.usernameAvailable(username);
          JuntoLoader.hide();

          if (!usernameAvailable) {
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
        //
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
        if (Validator.validateEmail(email) != null) {
          _showEmailError();
          return;
        }
        JuntoLoader.showLoader(context, color: Colors.transparent);
        // verify email address
        final emailAvailable = await userRepo.emailAvailable(email, username);
        if (emailAvailable) {
          final result = await authRepo.signUp(username, email, password);
          JuntoLoader.hide();
          if (!result.wasSuccessful) {
            _showSignUpError(result);
            return;
          }
        } else {
          JuntoLoader.hide();
          _showSignUpError(SignUpResult.emailTaken());
          return;
        }
      }
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

  void _showSignUpError(SignUpResult errorMessage) {
    String message = _getErrorMessage(errorMessage);
    showDialog(
      context: context,
      builder: (BuildContext context) => SingleActionDialog(
        dialogText: message,
      ),
    );
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

  void _showEmailError() {
    showDialog(
      context: context,
      builder: (BuildContext context) => SingleActionDialog(
        dialogText: S.of(context).welcome_invalid_email,
      ),
    );
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
    print(_currentIndex);
  }

  Future<bool> _animateOnBackPress() async {
    if (_currentIndex >= 1) {
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

  void _onSignUpSelected() {
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

  void _onSignInSelected() {
    _signInController.nextPage(
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 300),
    );
  }

  void _onBlocStateChange(BuildContext context, AuthState state) {
    print(state);
    if (state is AuthUnauthenticated) {
      if (state.error == true) {
        if (state.errorMessage != null && state.errorMessage.isNotEmpty) {
          showDialog(
            context: context,
            builder: (BuildContext context) => SingleActionDialog(
              dialogText: state.errorMessage,
            ),
          );
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => SingleActionDialog(
              dialogText: S.of(context).welcome_wrong_email_or_password,
            ),
          );
        }
      }
    }
  }

  String _getErrorMessage(SignUpResult result) {
    switch (result.error) {
      case SignUpResultError.UserAlreadyExists:
        return 'Account with this e-mail or username already exists';
      case SignUpResultError.InvalidPassword:
        return 'Seems like you entered incorrect password';
      case SignUpResultError.TooManyRequests:
        return 'You tried to register too many times. Try again later.';
      case SignUpResultError.UnknownError:
      default:
        return 'We cannot register you right now, sorry';
    }
  }
}
