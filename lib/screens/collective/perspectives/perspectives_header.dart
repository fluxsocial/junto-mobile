import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/create_perspective.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/overlay_info_icon.dart';

class PerspectivesAppbar extends StatelessWidget {
  const PerspectivesAppbar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      titleSpacing: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      brightness: Theme.of(context).brightness,
      title: Container(
        padding: const EdgeInsets.only(
          left: 20,
          right: 10,
        ),
        child: Row(
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
                  icon: JuntoDescribedFeatureOverlay(
                    icon: Icon(
                      Icons.add,
                      size: 24,
                      color: Theme.of(context).primaryColor,
                    ),
                    featureId: 'create_perspective_id',
                    title: 'Create a perspective.',
                    learnMore: false,
                    hasUpNext: false,
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: Icon(
                        Icons.add,
                        size: 24,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    FeatureDiscovery.clearPreferences(context, <String>{
                      'perspectives_info_id',
                      'create_perspective_id',
                      'collective_toggle_id',
                    });
                    FeatureDiscovery.discoverFeatures(
                      context,
                      const <String>{
                        'perspectives_info_id',
                        'create_perspective_id',
                        'collective_toggle_id',
                      },
                    );
                  },
                  child: JuntoDescribedFeatureOverlay(
                    icon: OverlayInfoIcon(),
                    featureId: 'perspectives_info_id',
                    title:
                        'This is your list of your perspectives. There are three by default - you can also make your own.',
                    learnMore: true,
                    hasUpNext: true,
                    learnMoreText: [
                      'Creating your own Perspective means creating your own feed with content from specific people. Our design inspiration here is to give you more agency over what you see, rather than building your feed with complex, opaque algorithms that form echo chambers and track your previous activity. Create your own perspective to organize what you care about.'
                    ],
                    upNextText: [
                      'Create perspectives that show expressions from specific people within certain channels',
                      'Share perspectives with others',
                      'Create sub perspectives'
                    ],
                    child: JuntoInfoIcon(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
