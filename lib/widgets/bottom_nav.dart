import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/screens/lotus/lotus.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({
    this.onLeftButtonTap,
    @required this.actionsVisible,
    this.address,
    this.expressionContext = ExpressionContext.Collective,
  });

  final VoidCallback onLeftButtonTap;
  final bool actionsVisible;
  final String address;
  final ExpressionContext expressionContext;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Theme.of(context).backgroundColor,
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: onLeftButtonTap,
              child: Container(
                width: 60,
                height: 50,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: RotatedBox(
                  quarterTurns: actionsVisible ? 2 : 0,
                  child: Icon(
                    CustomIcons.newdoubleuparrow,
                    size: 33,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  FadeRoute<void>(
                    child: JuntoLotus(
                      address: address,
                      expressionContext: expressionContext,
                    ),
                  ),
                  (route) => route.isFirst,
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
                child: Icon(
                  CustomIcons.newflower,
                  size: 33,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => JuntoFilterDrawer.of(context).toggleRightMenu(),
              child: Container(
                alignment: Alignment.center,
                width: 60,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  CustomIcons.drawermenu,
                  size: 38,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
