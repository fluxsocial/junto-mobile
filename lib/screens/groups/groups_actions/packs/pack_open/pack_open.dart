import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/packs/pack_open/pack_members.dart';
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
  final List<String> _tabs = <String>['Pack', 'Private', 'Members'];

  final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _shouldRefreshPublic = ValueNotifier<bool>(true);
  final ValueNotifier<bool> _shouldRefreshPack = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: child,
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: BottomNav(
            actionsVisible: false,
            onLeftButtonTap: () {},
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: DefaultTabController(
        length: _tabs.length,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
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
              child: TabBar(
                labelPadding: const EdgeInsets.all(0),
                isScrollable: true,
                labelColor: Theme.of(context).primaryColorDark,
                unselectedLabelColor: Theme.of(context).primaryColorLight,
                labelStyle: Theme.of(context).textTheme.subtitle1,
                indicatorWeight: 0.0001,
                tabs: <Widget>[
                  for (String name in _tabs)
                    Container(
                      color: Colors.transparent,
                      margin: const EdgeInsets.only(right: 20),
                      child: Text(
                        name.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  GroupExpressions(
                      key: const PageStorageKey<String>('public-pack'),
                      group: widget.pack,
                      userAddress: _userAddress,
                      expressionsPrivacy: 'Public',
                      shouldRefresh: _shouldRefreshPublic),
                  GroupExpressions(
                    key: const PageStorageKey<String>('private-pack'),
                    group: widget.pack,
                    userAddress: _userAddress,
                    expressionsPrivacy: 'Private',
                    shouldRefresh: _shouldRefreshPack,
                  ),
                  PackOpenMembers(
                    key: UniqueKey(),
                    packAddress: widget.pack.address,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
