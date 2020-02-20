import 'dart:async';
import 'dart:convert';
import 'package:async/async.dart' show AsyncMemoizer;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/previews/pack_preview.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';

class Packs extends StatefulWidget {
  const Packs({this.userProfile, this.changeGroup});

  final UserData userProfile;
  final Function changeGroup;

  @override
  State<StatefulWidget> createState() {
    return PacksState();
  }
}

class PacksState extends State<Packs> with ListDistinct {
  //ignore: unused_field
  String _userAddress;
  UserData _userProfile;
  UserRepo _userProvider;

  final AsyncMemoizer<UserGroupsResponse> _memoizer =
      AsyncMemoizer<UserGroupsResponse>();

  PageController packsPageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    getUserInformation();
    packsPageController = PageController(initialPage: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    setState(() {
      _userProvider = Provider.of<UserRepo>(context);
    });
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

  Future<UserGroupsResponse> getUserGroups() async {
    return _memoizer.runOnce(
      () => _userProvider.getUserGroups(_userProfile.user.address),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Theme.of(context).backgroundColor,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Packs', style: Theme.of(context).textTheme.headline4),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Container(
            color: Theme.of(context).backgroundColor,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    packsPageController.animateToPage(0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: _currentIndex == 0
                        ? BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Theme.of(context).primaryColorDark,
                                  width: 1.5),
                            ),
                          )
                        : null,
                    child: Text(
                      'My Packs',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _currentIndex == 0
                              ? Theme.of(context).primaryColorDark
                              : Theme.of(context).primaryColorLight,
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    packsPageController.animateToPage(1,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      border: _currentIndex == 1
                          ? Border(
                              bottom: BorderSide(
                                  color: Theme.of(context).primaryColorDark,
                                  width: 1.5),
                            )
                          : null,
                    ),
                    child: Text(
                      'Requests',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: _currentIndex == 1
                              ? Theme.of(context).primaryColorDark
                              : Theme.of(context).primaryColorLight,
                          decoration: TextDecoration.none),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: PageView(
              controller: packsPageController,
              onPageChanged: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: <Widget>[
                Column(
                  children: <Widget>[
                    if (_userProfile != null)
                      FutureBuilder<UserGroupsResponse>(
                        future: getUserGroups(),
                        builder: (BuildContext context,
                            AsyncSnapshot<UserGroupsResponse> snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return Expanded(
                              child: Center(
                                child: Transform.translate(
                                  offset: const Offset(0.0, -50),
                                  child: const Text(
                                      'Hmm, something is up with our server'),
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            final List<Group> ownedGroups = snapshot.data.owned;
                            final List<Group> associatedGroups =
                                snapshot.data.associated;
                            final List<Group> userPacks = distinct<Group>(
                                    ownedGroups, associatedGroups)
                                .where(
                                    (Group group) => group.groupType == 'Pack')
                                .toList();

                            return Expanded(
                                child: ListView(
                              padding: const EdgeInsets.all(0),
                              children: <Widget>[
                                for (Group group in userPacks)
                                  GestureDetector(
                                    onTap: () {
                                      widget.changeGroup(group);
                                    },
                                    child: PackPreview(
                                      group: group,
                                    ),
                                  )
                              ],
                            ));
                          }
                          return Expanded(
                            child: Center(
                              child: Transform.translate(
                                offset: const Offset(0.0, -50),
                                child: JuntoProgressIndicator(),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
                const Center(
                  child: Text('pack requests'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
