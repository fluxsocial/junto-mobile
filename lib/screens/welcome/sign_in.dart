import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';
import 'package:junto_beta_mobile/screens/lotus/lotus.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/buttons/call_to_action.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn(this.signInController);

  final PageController signInController;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Called when the user hits the `Sign In` button.
  /// Makes a call to [SharedPreferences] then replaces the current route
  /// with [JuntoCollective].
  Future<void> _handleSignIn(BuildContext context) async {
    logger.logInfo('User tapped sign in');
    final String email = _emailController.value.text;
    final String password = _passwordController.value.text;
    if (email.isEmpty || password.isEmpty) {
      _showValidationError();
      return;
    }
    final UserAuthLoginDetails loginDetails =
        UserAuthLoginDetails(email: email, password: password);
    JuntoLoader.showLoader(context);
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final bool nightMode = await prefs.getBool('night-mode');
      if (nightMode == null) {
        await prefs.setBool('night-mode', false);
      }
      await Provider.of<AuthRepo>(context, listen: false)
          .loginUser(loginDetails);
      JuntoLoader.hide();
      BlocProvider.of<PerspectivesBloc>(context).add(FetchPerspectives());
      Navigator.of(context).pushReplacement(JuntoLotusState.route());
    } catch (e, s) {
      logger.logException(e, s, 'Error during sign in');
      JuntoLoader.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) => const SingleActionDialog(
          dialogText:
              'Unable to login. Please double check your login credentials.',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        SignUpTextField(
                          hint: 'Email',
                          maxLength: 100,
                          textInputActionType: TextInputAction.next,
                          onSubmit: () {
                            FocusScope.of(context).nextFocus();
                          },
                          valueController: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                        ),
                        const SizedBox(height: 30),
                        SignUpTextField(
                          hint: 'Password',
                          maxLength: 100,
                          textInputActionType: TextInputAction.done,
                          onSubmit: () {
                            // FocusScope.of(context).unfocus();
                          },
                          obscureText: true,
                          valueController: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          textCapitalization: TextCapitalization.none,
                        ),
                        const SizedBox(height: 60),
                        CallToActionButton(
                          onSignUp: () {
                            _handleSignIn(context);
                          },
                          title: 'SIGN IN',
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          height: 70,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.bottomLeft,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              widget.signInController.previousPage(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 300),
              );
              if (FocusScope.of(context).hasFocus) {
                FocusScope.of(context).unfocus();
              }
            },
            child: Container(
              width: 38,
              height: 38,
              alignment: Alignment.centerLeft,
              child: Icon(
                CustomIcons.back,
                color: Colors.white70,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showValidationError() {
    showDialog(
      context: context,
      builder: (BuildContext context) => const SingleActionDialog(
        dialogText: 'Wrong email or password.',
      ),
    );
  }
}
