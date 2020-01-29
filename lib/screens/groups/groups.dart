import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/end_drawer/end_drawer.dart';
import 'package:junto_beta_mobile/widgets/utils/hide_fab.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/groups_actions.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/sphere_open/sphere_open.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/packs/pack_open/pack_open.dart';

// This screen displays groups a member belongs two. Currently, there are two types of
// groups: spheres (communities) and packs (agent-centric communities)
class JuntoGroups extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return JuntoGroupsState();
  }
}

class JuntoGroupsState extends State<JuntoGroups> with HideFab, ListDistinct {
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);
  String _userAddress;
  //ignore:unused_field
  UserData _userProfile;

  Group _currentGroup;

  bool actionsVisible = true;
  @override
  void initState() {
    super.initState();
    getUserInformation();
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData =
        jsonDecode(prefs.getString('user_data'));

    setState(() {
      _userAddress = prefs.getString('user_id');
      _userProfile = UserData.fromMap(decodedUserData);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentGroup = Group(
        address: null,
        groupType: 'Pack',
        creator: _userAddress,
        groupData: null,
        members: null,
        facilitators: null,
        privacy: 'Private',
        createdAt: null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const PreferredSize(
      //   preferredSize: Size.fromHeight(45),
      //   child: JuntoGroupsAppbar(),
      // ),
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
              screen: 'groups',
              onTap: () {
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      endDrawer: const JuntoDrawer(screen: 'Groups', icon: CustomIcons.groups),
      body: Stack(
        children: <Widget>[
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: actionsVisible ? 0.0 : 1.0,
            child: _displayGroup(_currentGroup),
          ),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: actionsVisible ? 1.0 : 0.0,
            child: Visibility(
              visible: actionsVisible,
              child: JuntoGroupsActions(
                changeGroup: _changeGroup,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _displayGroup(Group group) {
    if (group == null) {
      return Container();
    } else if (group.groupType == 'Pack') {
      return PackOpen(pack: group);
    } else if (group.groupType == 'Sphere') {
      return SphereOpen(group: group);
    }
    return Container();
  }

  void _changeGroup(Group group) {
    print(group.groupType);
    setState(() {
      _currentGroup = group;
      actionsVisible = false;
    });
  }
}
