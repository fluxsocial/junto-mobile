import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({
    this.onLeftButtonTap,
    @required this.actionsVisible,
  });

  final VoidCallback onLeftButtonTap;
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
              onTap: onLeftButtonTap,
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
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
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
                  CustomIcons.lotus,
                  size: 28,
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
                child: Image.asset(
                  'assets/images/junto-mobile__menu.png',
                  height: 8,
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
