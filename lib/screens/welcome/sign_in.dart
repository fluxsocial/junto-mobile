import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/lotus/lotus.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/buttons/call_to_action.dart';
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
    final String email = _emailController.value.text;
    final String password = _passwordController.value.text;
    final UserAuthLoginDetails loginDetails =
        UserAuthLoginDetails(email: email, password: password);
    JuntoLoader.showLoader(context);
    try {
      await Provider.of<AuthRepo>(context, listen: false)
          .loginUser(loginDetails);
      JuntoLoader.hide();
      Navigator.of(context).pushReplacement(
        PageRouteBuilder<dynamic>(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return const JuntoLotus(
              address: null,
              expressionContext: ExpressionContext.Collective,
            );
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(
            milliseconds: 1000,
          ),
        ),
      );
    } catch (error) {
      print(error);
      JuntoLoader.hide();
      JuntoDialog.showJuntoDialog(
          context,
          'Unable to login user. Please recheck your '
          'account.',
          <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 70),
          GestureDetector(
            onTap: () {
              widget.signInController.previousPage(
                curve: Curves.easeIn,
                duration: const Duration(milliseconds: 300),
              );
            },
            child: Container(
              width: 38,
              height: 38,
              alignment: Alignment.centerLeft,
              child: Icon(CustomIcons.back, color: Colors.white70, size: 20),
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height * .2),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: TextField(
                          controller: _emailController,
                          cursorColor: Colors.white70,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.green),
                            hintText: 'Email',
                            hintStyle: const TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            fillColor: Colors.white,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: TextField(
                          controller: _passwordController,
                          cursorColor: Colors.white70,
                          decoration: InputDecoration(
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            labelStyle: TextStyle(color: Colors.green),
                            hintText: 'Password',
                            hintStyle: const TextStyle(
                              color: Colors.white70,
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                            fillColor: Colors.white,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                CallToActionButton(
                  onSignUp: () {
                    _handleSignIn(context);
                  },
                  title: 'SIGN IN',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
