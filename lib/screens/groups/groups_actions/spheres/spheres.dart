import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/create_sphere/create_sphere.dart';
import 'package:junto_beta_mobile/screens/groups/groups_actions/spheres/spheres_search.dart';
import 'package:junto_beta_mobile/utils/junto_dialog.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart';
import 'package:junto_beta_mobile/utils/utils.dart';
import 'package:junto_beta_mobile/widgets/previews/sphere_preview/sphere_preview.dart';
import 'package:junto_beta_mobile/widgets/previews/sphere_preview/sphere_request.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Spheres extends StatefulWidget {
  const Spheres({
    this.userProfile,
    this.changeGroup,
  });

  final UserData userProfile;
  final Function changeGroup;

  @override
  State<StatefulWidget> createState() => SpheresState();
}

class SpheresState extends State<Spheres> with ListDistinct {
  UserData _userProfile;
  UserRepo _userProvider;
  NotificationRepo _notificationProvider;

  Future<UserGroupsResponse> getSpheres;
  Future<NotificationResultsModel> getSphereRequests;

  PageController circlesPageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    circlesPageController = PageController(initialPage: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserRepo>(context, listen: false);
    _notificationProvider =
        Provider.of<NotificationRepo>(context, listen: false);
    _refreshSpheres();
  }

  Future<void> _refreshSpheres() async {
    try {
      await getUserInformation();
      setState(() {
        getSpheres = getUserGroups();
        getSphereRequests = getGroupNotifications();
      });
    } on JuntoException catch (error) {
      JuntoDialog.showJuntoDialog(
        context,
        error.message,
        <Widget>[
          DialogBack(),
        ],
      );
    }
  }

  Future<void> getUserInformation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> decodedUserData =
        jsonDecode(prefs.getString('user_data'));
    setState(() {
      _userProfile = UserData.fromMap(decodedUserData);
    });
  }

  Future<UserGroupsResponse> getUserGroups() async {
    try {
      return _userProvider.getUserGroups(_userProfile.user.address);
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<NotificationResultsModel> getGroupNotifications() async {
    try {
      return _notificationProvider.getNotifications(
        const NotificationQuery(
          connectionRequests: false,
          groupJoinRequests: true,
          paginationPosition: 0,
        ),
      );
    } catch (error) {
      JuntoDialog.showJuntoDialog(
        context,
        error.message,
        <Widget>[
          DialogBack(),
        ],
      );
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
                Text('Circles', style: Theme.of(context).textTheme.headline4),
                Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute<dynamic>(
                            builder: (BuildContext context) =>
                                SpheresSearch(changeGroup: widget.changeGroup),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.transparent,
                        alignment: Alignment.centerRight,
                        height: 38,
                        width: 38,
                        child: Icon(
                          Icons.search,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute<void>(
                            builder: (BuildContext context) => CreateSphere(
                              refreshSpheres: _refreshSpheres,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.transparent,
                        width: 38,
                        height: 38,
                        child: Icon(
                          Icons.add,
                          size: 24,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
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
                    circlesPageController.animateToPage(0,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                  },
                  child: Container(
                    child: Text(
                      'My Circles',
                      style: TextStyle(
                          fontSize: 16,
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
                    circlesPageController.animateToPage(1,
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
                          decoration: TextDecoration.none),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: PageView(
              onPageChanged: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              controller: circlesPageController,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    if (_userProfile != null)
                      FutureBuilder<UserGroupsResponse>(
                        future: getSpheres,
                        builder: (BuildContext context,
                            AsyncSnapshot<UserGroupsResponse> snapshot) {
                          if (snapshot.hasError) {
                            print(snapshot.error);
                            return Expanded(
                              child: Center(
                                child: Transform.translate(
                                  offset: const Offset(0.0, -50),
                                  child: const Text(
                                    'Hmm, something is up with our server',
                                  ),
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasData) {
                            final List<Group> ownedGroups = snapshot.data.owned;
                            final List<Group> associatedGroups =
                                snapshot.data.associated;

                            final List<Group> userSpheres = distinct<Group>(
                              ownedGroups,
                              associatedGroups,
                            )
                                .where((Group group) =>
                                    group.groupType == 'Sphere')
                                .toList();

                            return Expanded(
                                child: ListView(
                              padding: const EdgeInsets.all(0),
                              children: <Widget>[
                                for (Group group in userSpheres)
                                  GestureDetector(
                                    onTap: () {
                                      widget.changeGroup(group);
                                    },
                                    child: SpherePreview(
                                      group: group,
                                    ),
                                  ),
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
                Column(
                  children: <Widget>[
                    if (_userProfile != null)
                      FutureBuilder<NotificationResultsModel>(
                        future: getSphereRequests,
                        builder: (BuildContext context,
                            AsyncSnapshot<NotificationResultsModel> snapshot) {
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
                            return Expanded(
                                child: ListView(
                              padding: const EdgeInsets.all(0),
                              children: <Widget>[
                                for (Group sphereRequest
                                    in snapshot.data.groupJoinNotifications)
                                  if (sphereRequest.groupType == 'Sphere')
                                    SphereRequest(
                                      sphere: sphereRequest,
                                      refreshGroups: _refreshSpheres,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
