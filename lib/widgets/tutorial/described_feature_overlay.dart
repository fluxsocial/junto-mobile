import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:feature_discovery/feature_discovery.dart';

class JuntoDescribedFeatureOverlay extends StatefulWidget {
  const JuntoDescribedFeatureOverlay({
    this.icon,
    this.featureId,
    this.title,
    this.contentLocation = ContentLocation.below,
    this.learnMore = false,
    this.isLastFeature = false,
    this.oneFeature = false,
    this.hasUpNext = false,
    this.learnMoreText,
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
  // has an up next / learn more section
  final bool hasUpNext;
  final String learnMoreText;
  final Widget child;

  @override
  State<StatefulWidget> createState() {
    return JuntoDescribedFeatureOverlayState();
  }
}

class JuntoDescribedFeatureOverlayState
    extends State<JuntoDescribedFeatureOverlay> {
  bool upNextVisible = false;
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
      tapTarget: widget.icon,
      featureId: widget.featureId,
      backgroundColor: Theme.of(context).accentColor,
      contentLocation: widget.contentLocation,
      overflowMode: OverflowMode.extendBackground,
      targetColor: Theme.of(context).backgroundColor,
      enablePulsingAnimation: false,
      description: Stack(
        children: <Widget>[
          _tutorialDescription(),
          _learnMore(
            context: context,
            learnMoreText: widget.learnMoreText,
            hasUpNext: false,
          ),
        ],
      ),
      child: widget.child,
    );
  }

  Widget _tutorialDescription() {
    return AnimatedOpacity(
      opacity: upNextVisible ? 0 : 1,
      duration: Duration(milliseconds: 300),
      child: Visibility(
        visible: !upNextVisible,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (widget.learnMore)
              _actionItemButton(
                context,
                'Learn More',
                () {
                  setState(() {
                    upNextVisible = true;
                  });
                },
              ),
            if (!widget.isLastFeature && !widget.oneFeature)
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
      ),
    );
  }

  Widget _learnMore(
      {BuildContext context,
      String learnMoreText,
      bool hasUpNext,
      String upNext}) {
    return AnimatedOpacity(
      opacity: upNextVisible ? 1 : 0,
      duration: Duration(milliseconds: 300),
      child: Visibility(
        visible: upNextVisible,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'DESIGN INSPIRATION',
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              learnMoreText,
              style: TextStyle(
                fontSize: 17,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (hasUpNext)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 25),
                  Text(
                    'UP NEXT',
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            GestureDetector(
              onTap: () {
                setState(() {
                  upNextVisible = false;
                });
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 0,
                ),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'BACK',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
