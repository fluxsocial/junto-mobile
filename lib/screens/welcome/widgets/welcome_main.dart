import 'package:flutter/material.dart';

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
                'assets/images/junto-mobile__logo--white.png',
                height: 69,
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
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 30,
                  left: 30,
                  right: 30,
                ),
                child: Container(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xff222222).withOpacity(.2),
                          offset: const Offset(0.0, 5.0),
                          blurRadius: 9,
                        ),
                      ],
                    ),
                    child: FlatButton(
                      color: Theme.of(context).accentColor,
                      onPressed: _onSignUp,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0)),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 30.0,
                        ),
                        child: Text(
                          'WELCOME TO THE PACK',
                          style: TextStyle(
                            letterSpacing: 1.2,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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
