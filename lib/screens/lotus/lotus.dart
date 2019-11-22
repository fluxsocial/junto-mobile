import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:junto_beta_mobile/screens/groups/groups.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';

class JuntoLotus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          child:
              Image.asset('assets/images/junto-mobile__background--lotus.png'),
        ),
        Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: EdgeInsets.only(top: 50, left: 50),
                height: 50,
                width: 50,
                child: Text('back'),
              ),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder<dynamic>(
                    pageBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return JuntoCreate('yo');
                    },
                    transitionsBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child,
                    ) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(
                      milliseconds: 400,
                    ),
                  ),
                );
              },
              child: Text('create'),
            ),            
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder<dynamic>(
                    pageBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return JuntoCollective();
                    },
                    transitionsBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child,
                    ) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(
                      milliseconds: 400,
                    ),
                  ),
                );
              },
              child: Text('collective'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder<dynamic>(
                    pageBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return JuntoGroups();
                    },
                    transitionsBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child,
                    ) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(
                      milliseconds: 400,
                    ),
                  ),
                );
              },
              child: Text('groups'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder<dynamic>(
                    pageBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return JuntoDen();
                    },
                    transitionsBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                      Widget child,
                    ) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(
                      milliseconds: 400,
                    ),
                  ),
                );
              },
              child: Text('den'),
            ),
          ],
        )
      ]),
    );
  }
}
