import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/lotus/lotus.dart';

class BottomNavNew extends StatelessWidget {
  BottomNavNew({this.screen, this.function});
  final screen;
  final function;

  _uniqueActionItem(context, currentScreen) {
    if (currentScreen == 'collective') {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            function();
          },
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
    } else if (currentScreen == 'spheres') {
      return Expanded(
        child: Container(
          width: 60,
          height: 50,
          child: Icon(CustomIcons.spheres,
              size: 17, color: Theme.of(context).primaryColor),
        ),
      );
    } else if (currentScreen == 'packs') {
      return Expanded(
        child: Container(
          width: 60,
          height: 50,
          child: Icon(CustomIcons.packs,
              size: 17, color: Theme.of(context).primaryColor),
        ),
      );
    } else if (currentScreen == 'den') {
      return Expanded(
        child: GestureDetector(
          onTap: () {
            function();
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
            function();
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
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).dividerColor,
              blurRadius: 3,
              spreadRadius: 2,
            )
          ]),
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
                      return JuntoLotus();
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
