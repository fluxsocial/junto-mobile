import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/sign_in/sign_in.dart';
import 'package:junto_beta_mobile/screens/sign_up/sign_up.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: <double>[0.1, 0.9],
            colors: <Color>[
              Color(0xff5E54D0),
              Color(
                0xff307FAB,
              ),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
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

              // Container(
              //   margin: EdgeInsets.only(bottom: 240),
              //   child: Text('a movement for authenticity', style:
              //   TextStyle(color: Colors.white, fontSize: 20,),)
              // ),
            ]),
            Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: RaisedButton(
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
                    // color: Colors.white,
                    color: const Color(0xff4968BF),
                    child: const Text(
                      'WELCOME TO THE PACK',
                      style: TextStyle(
                        // color: JuntoPalette.juntoBlue,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        100,
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
    );
  }
}
