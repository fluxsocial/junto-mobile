import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/logger/logger.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/event.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/longform.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/photo.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/shortform.dart';
import 'package:junto_beta_mobile/widgets/background/background_theme.dart';
import 'package:junto_beta_mobile/widgets/fade_route.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'create_actions/widgets/create_expression_icon.dart';
import 'create_actions/widgets/home_icon.dart';

class JuntoCreate extends StatefulWidget {
  const JuntoCreate({
    @required this.channels,
    @required this.address,
    @required this.expressionContext,
    @required this.currentTheme,
  });

  final List<String> channels;
  final String address;
  final ExpressionContext expressionContext;
  final ThemeData currentTheme;

  @override
  State<StatefulWidget> createState() {
    return JuntoCreateState();
  }
}

class JuntoCreateState extends State<JuntoCreate> {
  dynamic source;

  void _navigateTo(BuildContext context, ExpressionType expression) {
    switch (expression) {
      case ExpressionType.dynamic:
        _push(
            context,
            CreateLongform(
                expressionContext: widget.expressionContext,
                address: widget.address),
            expression);
        break;
      case ExpressionType.event:
        _push(
            context,
            CreateEvent(
                expressionContext: widget.expressionContext,
                address: widget.address),
            expression);
        break;
      case ExpressionType.shortform:
        _push(
            context,
            CreateShortform(
                expressionContext: widget.expressionContext,
                address: widget.address),
            expression);
        break;
      case ExpressionType.photo:
        _push(
            context,
            CreatePhoto(
              expressionContext: widget.expressionContext,
              address: widget.address,
            ),
            expression);
        break;
      default:
    }
  }

  void _push(
      BuildContext context, Widget form, ExpressionType expression) async {
    final ExpressionType expressionType = await Navigator.push(
      context,
      FadeRoute<ExpressionType>(
        child: form,
      ),
    );
    setState(() {
      source = expressionType;
    });
    logger.logDebug(source.toString());
  }

  Widget _expressionCenter(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: BackgroundTheme(
            currentTheme: widget.currentTheme,
          ),
        ),
        Positioned(
          bottom: 0,
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            FeatureDiscovery.clearPreferences(context, <String>{
                              'expression_center_id',
                            });
                            FeatureDiscovery.discoverFeatures(
                              context,
                              const <String>{
                                'expression_center_id',
                              },
                            );
                          },
                          child: JuntoDescribedFeatureOverlay(
                            icon: Icon(
                              CustomIcons.newcreate,
                              size: 36,
                              color: Theme.of(context).primaryColor,
                            ),
                            featureId: 'expression_center_id',
                            oneFeature: true,
                            title:
                                'This is the expression center, where you can create posts in a variety of forms. These will expand over time.',
                            learnMore: true,
                            learnMoreText: [
                              "We've become acclimated to a digital style of highly refined and curated sharing. Our goal with this expression center is to inspire a more authentic and lighthearted atmosphere through improvements on existing forms of sharing content and new mediums we haven't experienced yet. Let's explore these new possibilities together and figure out how we can make our digital experience more human.",
                              'We want to hear your ideas.'
                            ],
                            upNextText: [
                              'Audio, Video, Music, Links, Events, Poetry, and much more',
                            ],
                            hasUpNext: true,
                            child: JuntoInfoIcon(neutralBackground: false),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Row(
                          children: <Widget>[
                            _selectExpressionIcon(ExpressionType.dynamic),
                            _selectExpressionIcon(ExpressionType.shortform),
                            _selectExpressionIcon(ExpressionType.photo),
                          ],
                        ),
                      ),
                      HomeIcon(
                        source: source,
                        navigateTo: _navigateTo,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _expressionCenter(context),
    );
  }

  Widget _selectExpressionIcon(ExpressionType expressionType) {
    return CreateExpressionIcon(
      expressionType: expressionType,
      onTap: _navigateTo,
    );
  }
}
