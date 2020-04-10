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
    this.learnMoreText,
    this.isLastFeature = false,
    this.oneFeature = false,
    this.hasUpNext = false,
    this.upNextText,
    this.child,
  });

  final dynamic icon;
  final String featureId;

  final String title;
  final ContentLocation contentLocation;
  // if this feature has a learn more section
  final bool learnMore;
  final List<String> learnMoreText;
  // if this feature is the last one of the tutorial
  final bool isLastFeature;
  // only one feature in tutorial
  final bool oneFeature;
  // has an up next / learn more section
  final bool hasUpNext;
  final List<String> upNextText;
  final Widget child;

  @override
  State<StatefulWidget> createState() {
    return JuntoDescribedFeatureOverlayState();
  }
}

class JuntoDescribedFeatureOverlayState
    extends State<JuntoDescribedFeatureOverlay> {
  bool baseTutorialVisible = true;
  bool designInspirationVisible = false;
  bool comingSoonVisible = false;

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
      backgroundColor: Theme.of(context).colorScheme.primaryVariant,
      contentLocation: widget.contentLocation,
      overflowMode: OverflowMode.extendBackground,
      targetColor: Theme.of(context).backgroundColor,
      title: null,
      enablePulsingAnimation: false,
      description: Stack(
        children: <Widget>[
          _tutorialDescription(),
          _learnMore(
            context: context,
            learnMoreText: widget.learnMoreText,
            hasUpNext: widget.hasUpNext,
            upNextText: widget.upNextText,
          ),
          if (widget.hasUpNext)
            _comingSoon(
              context: context,
            ),
        ],
      ),
      child: widget.child,
    );
  }

  Widget _tutorialDescription() {
    return AnimatedOpacity(
      opacity: baseTutorialVisible ? 1 : 0,
      duration: Duration(milliseconds: 300),
      child: Visibility(
        visible: baseTutorialVisible,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (widget.learnMore)
              _actionItemButton(
                context,
                'Learn Why',
                () {
                  setState(() {
                    baseTutorialVisible = false;
                    designInspirationVisible = true;
                  });
                },
              ),
            if (!widget.isLastFeature && !widget.oneFeature)
              _actionItemButton(
                context,
                'Next Feature',
                () async => FeatureDiscovery.completeCurrentStep(context),
              ),
          ],
        ),
      ),
    );
  }

  Widget _learnMore({
    BuildContext context,
    List<String> learnMoreText,
    bool hasUpNext,
    List<String> upNextText,
  }) {
    return AnimatedOpacity(
      opacity: designInspirationVisible ? 1 : 0,
      duration: Duration(milliseconds: 300),
      child: Visibility(
        visible: designInspirationVisible,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .7,
              ),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                children: <Widget>[
                  Text(
                    'DESIGN INSPIRATION',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (learnMoreText != null)
                    for (String text in learnMoreText)
                      Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        child: Text(
                          text,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            height: 1.7,
                          ),
                        ),
                      ),
                ],
              ),
            ),
            Container(
              color: Colors.transparent,
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        designInspirationVisible = false;
                        baseTutorialVisible = true;
                      });
                    },
                    child: Container(
                      color: Colors.transparent,
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
                  ),
                  if (hasUpNext)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          designInspirationVisible = false;
                          comingSoonVisible = true;
                        });
                      },
                      child: Container(
                        color: Colors.transparent,
                        child: Row(
                          children: <Widget>[
                            Text(
                              'COMING SOON',
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
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _comingSoon({BuildContext context}) {
    return AnimatedOpacity(
      opacity: comingSoonVisible ? 1 : 0,
      duration: Duration(milliseconds: 300),
      child: Visibility(
        visible: comingSoonVisible,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * .7,
              ),
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                children: <Widget>[
                  Text(
                    'COMING SOON',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 20),
                  for (String text in widget.upNextText)
                    Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.label_important,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              text,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                height: 1.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  comingSoonVisible = false;
                  designInspirationVisible = true;
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
            ),
          ],
        ),
      ),
    );
  }
}
