import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:junto_beta_mobile/generated/l10n.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/screens/welcome/widgets/resend_verification_code_button.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class SignUpVerify extends StatefulWidget {
  const SignUpVerify({
    Key key,
    @required this.handleSignUp,
    @required this.verificationController,
    @required this.handleVerificationCode,
  }) : super(key: key);

  final TextEditingController verificationController;
  final VoidCallback handleSignUp;
  final VoidCallback handleVerificationCode;

  @override
  State<StatefulWidget> createState() {
    return SignUpVerifyState();
  }
}

class SignUpVerifyState extends State<SignUpVerify> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
      return Container(
        margin: EdgeInsets.only(top: size.height * .16),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: size.height * .24),
            Expanded(
              flex: 3,
              child: Container(
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: widget.verificationController,
                      maxLength: 8,
                      buildCounter: (
                        BuildContext context, {
                        int currentLength,
                        int maxLength,
                        bool isFocused,
                      }) =>
                          null,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.number,
                      keyboardAppearance: Theme.of(context).brightness,
                      maxLines: null,
                      cursorColor: JuntoPalette()
                          .juntoWhite(theme: theme)
                          .withOpacity(.70),
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        hintText: S.of(context).welcome_verification_code,
                        hintStyle: TextStyle(
                          color: JuntoPalette()
                              .juntoWhite(theme: theme)
                              .withOpacity(.70),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                        fillColor: JuntoPalette().juntoWhite(theme: theme),
                      ),
                      style: TextStyle(
                          color: JuntoPalette().juntoWhite(theme: theme),
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 6),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      S.of(context).welcome_check_email,
                      style: TextStyle(
                          color: JuntoPalette()
                              .juntoWhite(theme: theme)
                              .withOpacity(.70),
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ),
            ResendVerificationCodeButton(
              onPressed: widget.handleVerificationCode,
            ),
            SizedBox(height: 10.0),
            _SignUpButtons(
              theme: theme,
              onAction: widget.handleSignUp,
              text: S.of(context).welcome_lets_go,
            ),
            const Spacer(),
          ],
        ),
      );
    });
  }
}

class _SignUpButtons extends StatelessWidget {
  const _SignUpButtons({
    Key key,
    @required this.onAction,
    @required this.text,
    @required this.theme,
  }) : super(key: key);
  final VoidCallback onAction;
  final String text;
  final JuntoThemesProvider theme;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onAction,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 40),
        width: size.width,
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          borderRadius: BorderRadius.circular(1000),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Theme.of(context).primaryColorDark.withOpacity(.12),
              offset: const Offset(0.0, 6.0),
              blurRadius: 9,
            ),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            letterSpacing: 1.2,
            color: JuntoPalette().juntoWhite(theme: theme),
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
