import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:feature_discovery/feature_discovery.dart';

class ExpressionOpenAppbar extends StatelessWidget {
  const ExpressionOpenAppbar({this.expression});

  final ExpressionResponse expression;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      brightness: Theme.of(context).brightness,
      iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
      elevation: 0,
      titleSpacing: 0,
      title: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                color: Colors.transparent,
                width: 42,
                alignment: Alignment.centerLeft,
                child: Icon(
                  CustomIcons.back,
                  size: 17,
                  color: Theme.of(context).primaryColorDark,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                FeatureDiscovery.clearPreferences(context, <String>{
                  'expression_info_id',
                });
                FeatureDiscovery.discoverFeatures(
                  context,
                  const <String>{
                    'expression_info_id',
                  },
                );
              },
              child: JuntoDescribedFeatureOverlay(
                icon: Icon(
                  CustomIcons.newcreate,
                  size: 36,
                  color: Theme.of(context).primaryColor,
                ),
                featureId: 'expression_info_id',
                title:
                    "This screen shows a creator's expression. Click 'Learn Why' to read about our design inspiration",
                learnMore: true,
                hasUpNext: true,
                upNextText: [
                  'Ability to react and comment privately',
                  "Resonations (highlighting other people's content and adding comments on top)",
                  'Expression flags (i.e. "work in progress," "collaboration")',
                ],
                learnMoreText: [
                  'Our intention here is to reduce noise and group think where possible, encourage more presence while viewing content, and inspire authentic sharing by moving away from rating metrics that foster competitive and curated self-expression.',
                  'Within each expression, comments are hidden by default and reactions are only visible to the content creator.'
                ],
                child: JuntoInfoIcon(),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(.75),
        child: Container(
          height: .75,
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
          ),
        ),
      ),
    );
  }
}
