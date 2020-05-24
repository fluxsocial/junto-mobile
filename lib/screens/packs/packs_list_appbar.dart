import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:junto_beta_mobile/widgets/tutorial/described_feature_overlay.dart';
import 'package:junto_beta_mobile/widgets/tutorial/information_icon.dart';
import 'package:junto_beta_mobile/widgets/tutorial/overlay_info_icon.dart';

class PacksListAppBar extends StatelessWidget {
  PacksListAppBar({this.currentIndex});

  final int currentIndex;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * .1 + 50,
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * .1,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              left: 10,
              bottom: 10,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: .75,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 42,
                  height: 42,
                  alignment: Alignment.bottomLeft,
                  color: Colors.transparent,
                  child: Image.asset(
                    'assets/images/junto-mobile__logo--rainbow.png',
                    height: 24,
                  ),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          FeatureDiscovery.clearPreferences(context, <String>{
                            'packs_list_info_id',
                            'packs_toggle_id',
                          });
                          FeatureDiscovery.discoverFeatures(
                            context,
                            const <String>{
                              'packs_list_info_id',
                              'packs_toggle_id',
                            },
                          );
                        },
                        child: JuntoDescribedFeatureOverlay(
                          icon: OverlayInfoIcon(),
                          featureId: 'packs_list_info_id',
                          title:
                              'This is the list of Packs you belong to. Each person can only create one pack, but can belong to many others.',
                          learnMore: true,
                          learnMoreText: [
                            "Your Pack is your group of close friends who evoke the most unfiltered version of you and reflect an extension of you. The people you invite to your Pack will have access to your Pack feed, which displays the public content of everyone in it. In this light, you are the common thread between all the people you invite, facilitating a more organic way for them to hear from or discover one another through their mutual connection - you. You can also share private expressions to just your pack members.",
                            'Also note that connecting by Packs is not mutual. If someone accepts your pack invitation, you will not be able to see their Pack feed unless they choose to send you an invitation.'
                          ],
                          child: Container(
                            color: Colors.transparent,
                            alignment: Alignment.bottomRight,
                            child: JuntoInfoIcon(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: .75,
                ),
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Text(
                    'PACKS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          currentIndex == 0 ? FontWeight.w700 : FontWeight.w500,
                      color: currentIndex == 0
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).primaryColorLight,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 20),
                  child: Text(
                    'REQUESTS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          currentIndex == 1 ? FontWeight.w700 : FontWeight.w500,
                      color: currentIndex == 1
                          ? Theme.of(context).primaryColorDark
                          : Theme.of(context).primaryColorLight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
