import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/lotus/lotus.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/zoom_scaffold.dart';

class BottomNav extends StatelessWidget {
  const BottomNav(
      {this.screen,
      this.onTap,
      this.userProfile,
      @required this.actionsVisible});

  final String screen;
  final VoidCallback onTap;
  final UserData userProfile;
  final bool actionsVisible;

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
            offset: const Offset(0.0, 1.0),
            blurRadius: 6,
            spreadRadius: 1,
          )
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                  width: 60,
                  height: 50,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: RotatedBox(
                    quarterTurns: actionsVisible ? 2 : 0,
                    child: Image.asset(
                        'assets/images/junto-mobile__double-up-arrow.png',
                        height: 14,
                        color: Theme.of(context).primaryColor),
                  )),
            ),
          ),
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
                  color: Colors.transparent,
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
                Provider.of<MenuController>(context, listen: false).toggle();
              },
              child: Container(
                  alignment: Alignment.center,
                  width: 60,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Image.asset('assets/images/junto-mobile__menu.png',
                      height: 8, color: Theme.of(context).primaryColor)),
            ),
          ),
        ],
      ),
    );
  }
}
