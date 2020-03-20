import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/bloc/group_bloc.dart';
import 'package:junto_beta_mobile/user_data/user_data_provider.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/previews/pack_preview/pack_preview.dart';
import 'package:junto_beta_mobile/widgets/previews/pack_preview/pack_request.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Packs extends StatefulWidget {
  const Packs({this.userProfile, this.changeGroup});

  final UserData userProfile;
  final ValueChanged<Group> changeGroup;

  @override
  State<StatefulWidget> createState() {
    return PacksState();
  }
}

class PacksState extends State<Packs> {
  String _userAddress;

  GroupRepo _groupRepo;

  Future<UserGroupsResponse> userGroups;
  Future<NotificationResultsModel> userGroupRequests;

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
      _groupRepo = Provider.of<GroupRepo>(context, listen: false);
    });
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _userAddress = prefs.getString('user_id');
    });
  }

  Future<UserGroupsResponse> getUserGroups() async {
    try {
      return _groupRepo.getUserGroups(_userAddress);
    } catch (error) {
      print(error);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          const SizedBox(height: 45),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            color: Theme.of(context).backgroundColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Packs', style: Theme.of(context).textTheme.headline4),
                const SizedBox(
                  width: 38,
                  height: 38,
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: Theme.of(context).backgroundColor,
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    packsPageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Container(
                    child: Text(
                      'My Packs',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _currentIndex == 0
                            ? Theme.of(context).primaryColorDark
                            : Theme.of(context).primaryColorLight,
                        decoration: TextDecoration.none,
                      ),
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
                    child: Text(
                      'Requests',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _currentIndex == 1
                            ? Theme.of(context).primaryColorDark
                            : Theme.of(context).primaryColorLight,
                        decoration: TextDecoration.none,
                      ),
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
                MyPacks(
                  selectedGroup: widget.changeGroup,
                ),
                PackRequests(),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PackRequests extends StatefulWidget {
  @override
  _PackRequestsState createState() => _PackRequestsState();
}

class _PackRequestsState extends State<PackRequests> {
  UserData _userProfile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProfile = Provider.of<UserDataProvider>(context).userProfile;
  }

  Widget _loader() {
    return Expanded(
      child: Center(
        child: Transform.translate(
          offset: const Offset(0.0, -50),
          child: JuntoProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        BlocBuilder<GroupBloc, GroupBlocState>(
          builder: (BuildContext context, GroupBlocState state) {
            if (state is GroupLoading) {
              return _loader();
            }
            if (state is GroupLoaded) {
              return Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(0),
                  children: <Widget>[
                    for (Group packRequest
                        in state.notifications.groupJoinNotifications)
                      if (packRequest.groupType == 'Pack')
                        PackRequest(
                          userProfile: _userProfile,
                          pack: packRequest,
                          refreshGroups: () {},
                        )
                  ],
                ),
              );
            }
            if (state is GroupError) {
              return Expanded(
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(0.0, -50),
                    child: const Text('Hmm, something is up with our server'),
                  ),
                ),
              );
            }
            return _loader();
          },
        ),
      ],
    );
  }
}

class MyPacks extends StatefulWidget {
  const MyPacks({
    Key key,
    @required this.selectedGroup,
  }) : super(key: key);
  final ValueChanged<Group> selectedGroup;

  @override
  _MyPacksState createState() => _MyPacksState();
}

class _MyPacksState extends State<MyPacks> with ListDistinct {
  UserData _userProfile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProfile = Provider.of<UserDataProvider>(context).userProfile;
  }

  Widget _loader() {
    return Expanded(
      child: Center(
        child: Transform.translate(
          offset: const Offset(0.0, -50),
          child: JuntoProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        BlocBuilder<GroupBloc, GroupBlocState>(
          builder: (context, state) {
            print(state);
            if (state is GroupLoading) {
              return _loader();
            }
            if (state is GroupLoaded) {
              final List<Group> ownedGroups = state.groups.owned;
              final List<Group> associatedGroups = state.groups.associated;

              final List<Group> userPacks =
                  distinct<Group>(ownedGroups, associatedGroups)
                      .where((Group group) => group.groupType == 'Pack')
                      .toList();

              return Expanded(
                  child: ListView(
                padding: const EdgeInsets.all(0),
                children: <Widget>[
                  for (Group group in userPacks)
                    GestureDetector(
                      onTap: () => widget.selectedGroup(group),
                      child: PackPreview(
                        group: group,
                        userProfile: _userProfile,
                      ),
                    )
                ],
              ));
            }
            if (state is GroupError) {
              return Expanded(
                child: Center(
                  child: Transform.translate(
                    offset: const Offset(0.0, -50),
                    child: const Text('Hmm, something is up with our server'),
                  ),
                ),
              );
            }
            return SizedBox();
          },
        ),
      ],
    );
  }
}
