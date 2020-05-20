import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_in_back_nav.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/sign_up_text_field.dart';
import 'package:junto_beta_mobile/utils/form_validation.dart';
import 'package:junto_beta_mobile/widgets/buttons/call_to_action.dart';
import 'package:junto_beta_mobile/widgets/dialogs/single_action_dialog.dart';

import 'bloc/bloc.dart';

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

  Future<void> _handleSignIn(BuildContext context) async {
    logger.logInfo('User tapped sign in');
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      _showValidationError();
      return;
    }
    if (Validator.validateEmail(email) != null) {
      _showValidationError(S.of(context).welcome_invalid_email);
      return;
    }
    final UserAuthLoginDetails loginDetails =
        UserAuthLoginDetails(email: email, password: password);

    BlocProvider.of<AuthBloc>(context).add(LoginEvent(loginDetails));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: _onBlocStateChange,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: SignInBackNav(signInController: widget.signInController),
        ),
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
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
                      onSubmit: () async {
                        await _handleSignIn(context);
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
                        S.of(context).reset_password,
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
      ),
    );
  }

  void _showValidationError([String message]) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SingleActionDialog(
        dialogText: message ?? S.of(context).welcome_wrong_email_or_password,
      ),
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
}
