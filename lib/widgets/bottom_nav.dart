import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/screens/lotus/lotus.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({this.screen, this.onTap});

  final String screen;
  final VoidCallback onTap;

  Widget _uniqueActionItem(BuildContext context, String currentScreen) {
    if (currentScreen == 'collective') {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            alignment: Alignment.center,
            width: 60,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
            ),
            child: Transform.translate(
              offset: const Offset(-5, 0),
              child: Container(
                child: Icon(CustomIcons.collective,
                    size: 10, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ),
      );
    } else if (currentScreen == 'groups') {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            width: 60,
            height: 50,
            child: Icon(CustomIcons.groups,
                size: 17, color: Theme.of(context).primaryColor),
          ),
        ),
      );
    } else if (currentScreen == 'den') {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            width: 60,
            height: 50,
            child: Icon(CustomIcons.create,
                size: 17, color: Theme.of(context).primaryColor),
          ),
        ),
      );
    } else if (currentScreen == 'create') {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            onTap();
          },
          child: Container(
            width: 60,
            height: 50,
            child: Icon(CustomIcons.create,
                size: 17, color: Theme.of(context).primaryColor),
          ),
        ),
      );
    } else {
      return const SizedBox(width: 60);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Theme.of(context).backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context).dividerColor,
            blurRadius: 3,
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        children: <Widget>[
          _uniqueActionItem(context, screen),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  PageRouteBuilder<dynamic>(
                    pageBuilder: (
                      BuildContext context,
                      Animation<double> animation,
                      Animation<double> secondaryAnimation,
                    ) {
                      return const JuntoLotus(
                        address: null,
                        expressionContext: ExpressionContext.Collective,
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
                alignment: Alignment.center,
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(CustomIcons.lotus,
                    size: 28, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Scaffold.of(context).openEndDrawer();
              },
              child: Container(
                alignment: Alignment.center,
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(CustomIcons.morevertical,
                    size: 17, color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
