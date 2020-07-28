import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/buttons/call_to_action.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:provider/provider.dart';

class WelcomeMain extends StatelessWidget {
  const WelcomeMain({
    Key key,
    @required VoidCallback onSignIn,
    @required VoidCallback onSignUp,
  })  : _onSignIn = onSignIn,
        _onSignUp = onSignUp,
        super(key: key);

  final VoidCallback _onSignIn;
  final VoidCallback _onSignUp;

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(builder: (context, theme, child) {
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
                  'assets/images/junto-mobile__logo.png',
                  height: 69,
                  color: JuntoPalette().juntoWhite(theme: theme),
                ),
              ),
              Container(
                child: Text(
                  'JUNTO',
                  style: TextStyle(
                    color: JuntoPalette().juntoWhite(theme: theme),
                    fontSize: 45,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ]),
            Column(
              children: <Widget>[
                CallToActionButton(
                  callToAction: _onSignUp,
                  title: 'CREATE AN ACCOUNT',
                ),
                const SizedBox(height: 15),
                CallToActionButton(
                  callToAction: _onSignIn,
                  title: 'SIGN IN',
                  transparent: true,
                ),
                SizedBox(height: 120),
              ],
            )
          ],
        ),
      );
    });
  }
}
