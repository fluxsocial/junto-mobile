import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feature_discovery/feature_discovery.dart';

class JuntoDescribedFeatureOverlay extends StatelessWidget {
  const JuntoDescribedFeatureOverlay({
    this.icon,
    this.featureId,
    this.title,
    this.contentLocation = ContentLocation.below,
    this.learnMore = false,
    this.isLastFeature = false,
    this.oneFeature = false,
    this.child,
  });

  final dynamic icon;
  final String featureId;
  final String title;
  final ContentLocation contentLocation;
  // if this feature has a learn more section
  final bool learnMore;
  // if this feature is the last one of the tutorial
  final bool isLastFeature;
  // only one feature in tutorial
  final bool oneFeature;
  final Widget child;

  _actionItemButton(BuildContext context, String name, Function onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          children: <Widget>[
            Text(
              name.toUpperCase(),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 10),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DescribedFeatureOverlay(
      tapTarget: icon,
      featureId: featureId,
      backgroundColor: Theme.of(context).accentColor,
      contentLocation: contentLocation,
      overflowMode: OverflowMode.extendBackground,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      targetColor: Theme.of(context).backgroundColor,
      enablePulsingAnimation: false,
      description: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (learnMore)
            _actionItemButton(
              context,
              'Learn More',
              () {},
            ),
          if (!isLastFeature && !oneFeature)
            _actionItemButton(
              context,
              'Next Feature',
              () async => FeatureDiscovery.completeCurrentStep(context),
            ),
          _actionItemButton(
            context,
            'Dismiss',
            () async => FeatureDiscovery.dismissAll(context),
          ),
        ],
      ),
      child: child,
    );
  }
}
