import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/collective/collective.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';
import 'package:junto_beta_mobile/screens/den/den.dart';
import 'package:junto_beta_mobile/screens/groups/groups.dart';

class JuntoLotus extends StatelessWidget {
  const JuntoLotus({
    Key key,
    @required this.expressionContext,
    @required this.address,
  })  : assert(expressionContext != null),
        assert(address != ''),
        super(key: key);
  final ExpressionContext expressionContext;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
          child:
              Image.asset('assets/images/junto-mobile__background--lotus.png'),
        ),
        Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 100),
                child: const Text(
                  '',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Container(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder<dynamic>(
                                pageBuilder: (
                                  BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation,
                                ) {
                                  return JuntoCreate(
                                    channels: [],
                                    address: address,
                                    expressionContext: expressionContext,
                                  );
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
                                  milliseconds: 300,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 40),
                            width: MediaQuery.of(context).size.width * .5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 27,
                                  child: Icon(CustomIcons.create,
                                      size: 20, color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'CREATE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.4),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
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
                                  milliseconds: 300,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(right: 40),
                            width: MediaQuery.of(context).size.width * .5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Transform.translate(
                                  offset: const Offset(-5, 0),
                                  child: Icon(CustomIcons.groups,
                                      size: 20, color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'CONNECT',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.4),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
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
                                  milliseconds: 300,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width * .5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 45,
                                  child: Icon(CustomIcons.collective,
                                      size: 15, color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'DISCOVER',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.4),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
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
                                  milliseconds: 300,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            alignment: Alignment.center,
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width * .5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Transform.translate(
                                  offset: const Offset(-15, 0),
                                  child: Icon(CustomIcons.collective,
                                      size: 15, color: Colors.white),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'REFLECT',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.4),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      color: Colors.transparent,
                      height: 50,
                      margin: const EdgeInsets.only(bottom: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(CustomIcons.lotus, size: 28, color: Colors.white)
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ]),
    );
  }
}
