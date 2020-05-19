import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/screens.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:junto_beta_mobile/screens/lotus/lotus.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:feature_discovery/feature_discovery.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({
    this.onLeftButtonTap,
    @required this.actionsVisible,
    this.address,
    this.expressionContext = ExpressionContext.Collective,
    this.featureTitle = '',
    this.iconNorth = true,
    this.isLastFeature = true,
    this.featureId = '',
    this.source,
  });

  final VoidCallback onLeftButtonTap;
  final bool actionsVisible;
  final String address;
  final ExpressionContext expressionContext;
  final bool iconNorth;
  final String featureTitle;
  final String featureId;
  final bool isLastFeature;
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
            child: JuntoDescribedFeatureOverlay(
              icon: RotatedBox(
                quarterTurns: iconNorth ? 0 : 2,
                child: Icon(
                  CustomIcons.newdoubleuparrow,
                  size: 33,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              featureId: featureId,
              title: featureTitle,
              contentLocation: ContentLocation.above,
              learnMore: false,
              isLastFeature: isLastFeature,
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
