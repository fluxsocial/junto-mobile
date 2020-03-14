import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/groups_actions.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/packs/pack_open/pack_open.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/sphere_open/sphere_open.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/drawer/filter_drawer_content.dart';
import 'package:junto_beta_mobile/widgets/drawer/junto_filter_drawer.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';

// This screen displays groups a member belongs two. Currently, there are two types of
// groups: spheres (communities) and packs (agent-centric communities)
class JuntoGroups extends StatefulWidget {
  const JuntoGroups({@required this.initialGroup});

  final String initialGroup;

  @override
  State<StatefulWidget> createState() {
    return JuntoGroupsState();
  }
}

class JuntoGroupsState extends State<JuntoGroups>
    with HideFab, ListDistinct, TickerProviderStateMixin {
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);
  GlobalKey<JuntoFilterDrawerState> _filterDrawerKey;

  bool actionsVisible = false;
  Widget _currentGroup;
  bool spheresVisible = false;

  @override
  void initState() {
    super.initState();
    getUserInformation();
  }

  Future<void> getUserInformation() async {
    final Group group = await Provider.of<GroupRepo>(context, listen: false)
        .getGroup(widget.initialGroup);

    if (group.groupType == 'Pack') {
      setState(() {
        _currentGroup = PackOpen(pack: group);
      });
    } else if (group.groupType == 'Sphere') {
      setState(() {
        _currentGroup = SphereOpen(group: group);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JuntoFilterDrawer(
        key: _filterDrawerKey,
        leftDrawer: FilterDrawerContent(
          //todo(dominikroszkowski): implement these
          filterByChannel: (_) {},
          channels: [],
          resetChannels: () {},
        ),
        rightMenu: JuntoDrawer(),
        scaffold: Scaffold(
          floatingActionButton: ValueListenableBuilder<bool>(
            valueListenable: _isVisible,
            builder: (BuildContext context, bool visible, Widget child) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: visible ? 1.0 : 0.0,
                child: child,
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: BottomNav(
                  actionsVisible: actionsVisible,
                  onLeftButtonTap: () {
                    if (actionsVisible) {
                      setState(() {
                        actionsVisible = false;
                      });
                    } else {
                      setState(() {
                        actionsVisible = true;
                      });
                    }
                  }),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: Stack(
            children: <Widget>[
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: actionsVisible ? 0.0 : 1.0,
                child: _currentGroup,
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: actionsVisible ? 1.0 : 0.0,
                child: Visibility(
                  visible: actionsVisible,
                  child: JuntoGroupsActions(
                    changeGroup: _changeGroup,
                    spheresVisible: spheresVisible,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeGroup(Group group) {
    if (group.groupType == 'Pack') {
      setState(() {
        _currentGroup = PackOpen(pack: group);
        spheresVisible = false;
      });
    }

    if (group.groupType == 'Sphere') {
      setState(() {
        _currentGroup = const SizedBox();
      });
      setState(() {
        _currentGroup = SphereOpen(
          group: group,
        );
      });
      spheresVisible = true;
    }

    actionsVisible = false;
  }
}
