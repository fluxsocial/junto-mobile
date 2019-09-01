import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/route_animations/route_main_screens/route_main_screens.dart';
import 'package:junto_beta_mobile/screens/template/template.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This page checks the authentication state of the user then directs them to
/// the appropriate screen.
/// While this is on going, the page fades in the Junto logo and text using a
/// pair of [Interval] curves.
/// The checks for determining whether the authentication state of the given
/// user is done in [didChangeDependencies] since the context is available
/// allowing us to call `Navigator.of(context)`
class JuntoLoading extends StatefulWidget {
  @override
  _JuntoLoadingState createState() => _JuntoLoadingState();
}

class _JuntoLoadingState extends State<JuntoLoading> with SingleTickerProviderStateMixin {
  // Controller used to drive both animations
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1500,
      ),
    );
    controller.forward();
  }

  @override
  void didChangeDependencies() {
    // Steps: Call secure storage
    //  get the isLoggedIn key
    // navigate to [Welcome] or home
    // clean up?
    _checkAuthStatus();
    super.didChangeDependencies();
  }

  /// This function does the heavy lifting of calling secure storage and
  /// checking for the appropriate key/value.
  Future<void> _checkAuthStatus() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final bool isLoggedIn = preferences.getBool('isLoggedIn');
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (isLoggedIn != null && isLoggedIn == true ) {
      Navigator.of(context).pushReplacement(
        CustomRoute<dynamic>(
          builder: (BuildContext context) => JuntoTemplate(),
        ),
      );
    } else {
      Navigator.of(context).pushReplacement(
        CustomRoute<dynamic>(
          builder: (BuildContext context) => Welcome(),
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.shortestSide,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: <double>[0.1, 0.9],
            colors: <Color>[
              Color(0xff5E54D0),
              Color(0xff307FAB),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Column(
              children: <Widget>[
                AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget child) {
                    return FadeTransition(
                      opacity: CurvedAnimation(
                        parent: controller,
                        curve: Interval(
                          0.0,
                          0.5,
                          curve: Curves.ease,
                        ),
                      ),
                      child: child,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 120, bottom: 23),
                    child: Image.asset(
                      'assets/images/junto-mobile__logo--white.png',
                      height: 69,
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: controller,
                  builder: (BuildContext context, Widget child) {
                    return FadeTransition(
                        opacity: CurvedAnimation(
                          curve: Interval(
                            0.5,
                            1.0,
                            curve: Curves.easeInSine,
                          ),
                          parent: controller,
                        ),
                        child: child);
                  },
                  child: Container(
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
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
