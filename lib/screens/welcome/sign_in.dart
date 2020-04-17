import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_in_back_nav.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/collective/perspectives/bloc/perspectives_bloc.dart';
import 'package:junto_beta_mobile/screens/lotus/lotus.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field.dart';
import 'package:junto_beta_mobile/utils/junto_overlay.dart';
import 'package:junto_beta_mobile/widgets/buttons/call_to_action.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:feature_discovery/feature_discovery.dart';
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
    final String email = _emailController.value.text.trim();
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
      Provider.of<UserDataProvider>(context, listen: false).initialize();
      JuntoLoader.hide();
      BlocProvider.of<PerspectivesBloc>(context).add(FetchPerspectives());
      Navigator.of(context).pushReplacement(
        FadeRoute<void>(
          child: FeatureDiscovery(
            child: const JuntoLotus(
              address: null,
              expressionContext: ExpressionContext.Collective,
              source: null,
            ),
          ),
        ),
      );
    } catch (e, s) {
      logger.logException(e, s, 'Error during sign in');
      JuntoLoader.hide();
      showDialog(
        context: context,
        builder: (BuildContext context) => SingleActionDialog(
          dialogText: S.of(context).welcome_unable_to_login,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: SignInBackNav(signInController: widget.signInController),
      ),
      backgroundColor: Colors.transparent,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SignUpTextField(
                    hint: S.of(context).welcome_email_hint,
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
                    hint: S.of(context).welcome_password_hint,
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
                ],
              ),
            ),
            Column(
              children: [
                CallToActionButton(
                  callToAction: () {
                    _handleSignIn(context);
                  },
                  title: S.of(context).welcome_sign_in,
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () {
                    widget.signInController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.decelerate,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 120),
                    child: Text(
                      'RESET PASSWORD',
                      style: TextStyle(
                        letterSpacing: 1.7,
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showValidationError() {
    showDialog(
      context: context,
      builder: (BuildContext context) => SingleActionDialog(
        dialogText: S.of(context).welcome_wrong_email_or_password,
      ),
    );
  }
}
