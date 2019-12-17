import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/sign_in/sign_in.dart';
import 'package:junto_beta_mobile/screens/sign_up/sign_up.dart';

class Welcome extends StatelessWidget {
  static Route<dynamic> route() {
    return MaterialPageRoute<dynamic>(
      builder: (BuildContext context) {
        return Welcome();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
              'assets/images/junto-mobile__background--lotus.png',
              fit: BoxFit.cover),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(top: 120, bottom: 23),
                  child: Image.asset(
                    'assets/images/junto-mobile__logo--white.png',
                    height: 69,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 45),
                  child: const Text(
                    'JUNTO',
                    style: TextStyle(
                      letterSpacing: 1.7,
                      color: Colors.white,
                      fontSize: 45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ]),
              Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => SignUp(),
                          ),
                        );
                      },
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 20,
                      ),
                      color: Colors.transparent,
                      child: const Text(
                        'WELCOME TO THE PACK',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 120),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => SignIn(),
                          ),
                        );
                      },
                      child: const Text(
                        'SIGN IN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ]),
    );
  }
}
