import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/create_perspective.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';

class PerspectivesAppbar extends StatelessWidget {
  const PerspectivesAppbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      brightness: Theme.of(context).brightness,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            'Perspectives',
            style: Theme.of(context).textTheme.headline4,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              IconButton(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(0),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute<dynamic>(
                      builder: (ctx) => CreatePerspectivePage(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.add,
                  size: 24,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              GestureDetector(
                onTap: () {
                  FeatureDiscovery.clearPreferences(context, <String>{
                    'perspectives_info_id',
                    'collective_toggle_id',
                  });
                  FeatureDiscovery.discoverFeatures(
                    context,
                    const <String>{
                      'perspectives_info_id',
                      'collective_toggle_id',
                    },
                  );
                },
                child: JuntoDescribedFeatureOverlay(
                  icon: Icon(
                    CustomIcons.newbinoculars,
                    size: 36,
                    color: Colors.white,
                  ),
                  featureId: 'perspectives_info_id',
                  title:
                      'This is your list of your perspectives. There are three by default - you can also make your own.',
                  learnMore: true,
                  hasUpNext: true,
                  learnMoreText:
                      'Our design inspiration here is to give you more agency over what you see, rather than applying complex, opaque algorithms that form echo chambers and track your previous activity. Create your own perspective to see expressions from specific people and organize what you care about.',
                  upNextText: [
                    'Create perspectives that show expressions from specific people in certain channels.',
                    'Share perspectives with others',
                    'Create sub perspectives'
                  ],
                  child: Container(
                    alignment: Alignment.bottomRight,
                    padding: const EdgeInsets.only(left: 10),
                    child: JuntoInfoIcon(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
