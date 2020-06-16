import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/buttons/call_to_action.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
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
                  color: theme.themeName.contains('sand')
                      ? Color(0xff555555)
                      : Colors.white,
                ),
              ),
              Container(
                child: Text(
                  'JUNTO',
                  style: TextStyle(
                    letterSpacing: 3.6,
                    color: theme.themeName.contains('sand')
                        ? Color(0xff555555)
                        : Colors.white,
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
                  title: 'WELCOME TO THE PACK',
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.only(bottom: 120),
                  child: GestureDetector(
                    onTap: _onSignIn,
                    child: Text(
                      'SIGN IN',
                      style: TextStyle(
                        letterSpacing: 1.7,
                        color: theme.themeName.contains('sand')
                            ? Color(0xff555555)
                            : Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
