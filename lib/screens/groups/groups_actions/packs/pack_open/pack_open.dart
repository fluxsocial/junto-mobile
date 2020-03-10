import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/packs/pack_open/pack_open_appbar.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/packs/pack_open/pack_members.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/group_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/backend/repositories.dart';

class PackOpen extends StatefulWidget {
  const PackOpen({
    Key key,
    @required this.pack,
  }) : super(key: key);

  final Group pack;

  @override
  State<StatefulWidget> createState() {
    return PackOpenState();
  }
}

class PackOpenState extends State<PackOpen> {
  String _userAddress;
  UserData _userProfile;
  int _currentIndex = 0;

  Future<List<Users>> getPackMembers;

  // Controller for PageView
  PageController controller;
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getPackMembers = Provider.of<GroupRepo>(context, listen: false)
        .getGroupMembers(widget.pack.address);
  }

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    getUserInformation();
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData = jsonDecode(
      prefs.getString('user_data'),
    );

    setState(() {
      _userAddress = prefs.getString('user_id');
      _userProfile = UserData.fromMap(decodedUserData);
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Widget _buildTab(String name, int index) {
    return GestureDetector(
      onTap: () {
        controller.jumpToPage(index);
      },
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.only(right: 20),
        child: Text(
          name.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: _currentIndex == index
                ? Theme.of(context).primaryColor
                : Theme.of(context).primaryColorLight,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: PackOpenAppbar(
            pack: widget.pack,
            userProfile: _userProfile,
          ),
        ),
        floatingActionButton: ValueListenableBuilder<bool>(
          valueListenable: _isVisible,
          builder: (BuildContext context, bool visible, Widget child) {
            return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: visible ? 1.0 : 0.0,
                child: child);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 25),
            child: BottomNav(
                actionsVisible: false,
                screen: 'collective',
                userProfile: _userProfile,
                onTap: () {}),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  _buildTab('Pack', 0),
                  _buildTab('Private', 1),
                  _buildTab('Members', 2)
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                children: <Widget>[
                  GroupExpressions(
                    group: widget.pack,
                    userAddress: _userAddress,
                    expressionsPrivacy: 'Public',
                    openFilterDrawer: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                  GroupExpressions(
                      group: widget.pack,
                      userAddress: _userAddress,
                      expressionsPrivacy: 'Private',
                      openFilterDrawer: () {
                        Scaffold.of(context).openDrawer();
                      }),
                  PackOpenMembers(getPackMembers: getPackMembers)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
