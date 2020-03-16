import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/buttons/call_to_action.dart';

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
                color: Colors.white,
              ),
            ),
            Container(
              child: const Text(
                'JUNTO',
                style: TextStyle(
                  letterSpacing: 3.6,
                  color: Colors.white,
                  fontSize: 45,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ]),
          Column(
            children: <Widget>[
              CallToActionButton(
                onSignUp: _onSignUp,
                title: 'WELCOME TO THE PACK',
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 120),
                child: GestureDetector(
                  onTap: _onSignIn,
                  child: const Text(
                    'SIGN IN',
                    style: TextStyle(
                        letterSpacing: 1.2,
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
