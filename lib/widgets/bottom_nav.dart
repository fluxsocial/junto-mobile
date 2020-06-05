import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/screens.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/screens/global_search/global_search.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({
    this.address,
    this.expressionContext = ExpressionContext.Collective,
    this.source,
  });

  final String address;
  final ExpressionContext expressionContext;
  final Screen source;

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
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  FadeRoute<void>(
                    child: GlobalSearch(),
                  ),
                );
              },
              child: Container(
                width: 60,
                height: 50,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Icon(
                  Icons.search,
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.popUntil(context, (r) => r.isFirst);
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
                  size: 38,
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
