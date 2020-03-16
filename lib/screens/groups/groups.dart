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
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:provider/provider.dart';

// This screen displays groups a member belongs to. Currently, there are two types of
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
  bool spheresVisible = false;
  final List<String> _channels = <String>[];
  Group _currentGroup;

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
        _currentGroup = group;
      });
    } else if (group.groupType == 'Sphere') {
      setState(() {
        _currentGroup = group;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: JuntoFilterDrawer(
        key: _filterDrawerKey,
        leftDrawer: FilterDrawerContent(
          filterByChannel: _filterByChannel,
          channels: _channels,
          resetChannels: _resetChannels,
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
                child: Builder(
                  builder: (BuildContext context) {
                    if (_currentGroup == null) {
                      return JuntoProgressIndicator();
                    }
                    if (_currentGroup.groupType == 'Pack') {
                      return PackOpen(
                        key: ValueKey<String>(_currentGroup.address),
                        pack: _currentGroup,
                        channels: _channels,
                      );
                    } else if (_currentGroup.groupType == 'Sphere') {
                      return SphereOpen(
                        key: ValueKey<String>(_currentGroup.address),
                        group: _currentGroup,
                        channels: _channels,
                      );
                    }
                    return Container();
                  },
                ),
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

  void _filterByChannel(Channel channel) {
    setState(() {
      if (_channels.isEmpty) {
        _channels.add(channel.name);
      } else {
        _channels.first = channel.name;
      }
    });
  }

  void _resetChannels() {
    setState(() {
      _channels.clear();
    });
    Navigator.pop(context);
  }

  void _changeGroup(Group group) {
    if (group.groupType == 'Pack') {
      setState(() {
        _currentGroup = group;
        spheresVisible = false;
      });
    }

    if (group.groupType == 'Sphere') {
      setState(() {
        _currentGroup = null;
      });
      setState(() {
        _currentGroup = group;
      });
      spheresVisible = true;
    }

    actionsVisible = false;
  }
}
