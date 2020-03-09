import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/packs/pack_open/pack_open_appbar.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/widgets/custom_feeds/group_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // Controller for PageView
  PageController controller;
  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: 0);
    getUserInformation();
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData = await jsonDecode(
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
                  GestureDetector(
                    onTap: () => controller.jumpToPage(0),
                    child: Container(
                      color: Colors.transparent,
                      child: Text(
                        'PACK',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _currentIndex == 0
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).primaryColorLight,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      controller.jumpToPage(1);
                    },
                    child: Container(
                        color: Colors.transparent,
                        child: Text(
                          'PRIVATE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _currentIndex == 1
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).primaryColorLight,
                          ),
                        )),
                  ),
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
                      expressionsPrivacy: 'Public'),
                  GroupExpressions(
                    group: widget.pack,
                    userAddress: _userAddress,
                    expressionsPrivacy: 'Private',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
