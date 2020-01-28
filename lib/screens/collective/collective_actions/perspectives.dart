import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/screens/collective/collective_actions/create_perspective.dart';
import 'package:junto_beta_mobile/utils/junto_exception.dart'
    show JuntoException;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JuntoPerspectives extends StatefulWidget {
  const JuntoPerspectives({this.userProfile, this.changePerspective});

  final UserData userProfile;
  final Function changePerspective;

  @override
  State<StatefulWidget> createState() {
    return JuntoPerspectivesState();
  }
}

class JuntoPerspectivesState extends State<JuntoPerspectives> {
  String _userAddress;
  UserData _userProfile;

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

  Future<List<CentralizedPerspective>> _fetchUserPerspectives(String address) {
    try {
      return Provider.of<UserRepo>(context).getUserPerspective(_userAddress);
    } on JuntoException catch (error) {
      debugPrint('error fethcing perspectives ${error.errorCode}');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 150,
      child:
          Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
              Widget>[
        Container(
          height: 100,
          padding: const EdgeInsets.symmetric(vertical: 10),
          color: Theme.of(context).backgroundColor,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('Perspectives', style: Theme.of(context).textTheme.display1),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute<dynamic>(
                      builder: (BuildContext context) => CreatePerspective(),
                    ),
                  );
                },
                child: Icon(Icons.add,
                    size: 24, color: Theme.of(context).primaryColor),
              )
            ],
          ),
        ),
        const SizedBox(height: 10),
        // Container(
        //   height: 50,
        //   color: Theme.of(context).backgroundColor,
        //   child: Row(
        //     children: <Widget>[
        //       Container(
        //           padding: const EdgeInsets.all(10),
        //           decoration: BoxDecoration(
        //             borderRadius: BorderRadius.circular(5),
        //             color: const Color(0xff555555),
        //           ),
        //           child: Text(
        //             'All',
        //             style: TextStyle(
        //                 fontSize: 12,
        //                 fontWeight: FontWeight.w700,
        //                 color: Colors.white,
        //                 decoration: TextDecoration.none),
        //           ))
        //     ],
        //   ),
        // ),
        Expanded(
            child: ListView(
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            _buildPerspective(
              const CentralizedPerspective(
                address: null,
                name: 'JUNTO',
                about: null,
                creator: null,
                createdAt: null,
                isDefault: null,
                userCount: null,
                users: null,
              ),
            ),
            _userAddress != null
                ? FutureBuilder<List<CentralizedPerspective>>(
                    future: _fetchUserPerspectives(_userAddress),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<List<CentralizedPerspective>> snapshot,
                    ) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Container(
                          child: const Text(
                            'hmm, something is up...',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                        );
                      }
                      if (snapshot.hasData) {
                        return ListView(
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            children: snapshot.data
                                .map((CentralizedPerspective perspective) {
                              if (perspective.name != 'Connections') {
                                return GestureDetector(
                                  child: _buildPerspective(perspective),
                                );
                              } else {
                                return const SizedBox();
                              }
                            }).toList());
                      }
                      return Container();
                    },
                  )
                : const SizedBox(),
          ],
        ))
      ]),
    );
  }

  Widget _buildPerspective(CentralizedPerspective perspective) {
    return GestureDetector(
      onTap: () => widget.changePerspective(perspective),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom:
                BorderSide(color: Theme.of(context).dividerColor, width: .75),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 45.0,
              width: 45.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: const <double>[0.2, 0.9],
                  colors: <Color>[
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.primary
                  ],
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset('assets/images/junto-mobile__binoculars.png',
                  height: 15, color: Colors.white),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(perspective.name,
                      style: Theme.of(context).textTheme.subhead),
                  if (perspective.name == 'JUNTO')
                    Text(
                      'Expressions from everyone in Junto.',
                      style: Theme.of(context).textTheme.body2,
                    ),
                  if (perspective.name == 'Subscriptions')
                    Text(
                      'Expressions from specific people you\'re subscribed to.',
                      style: Theme.of(context).textTheme.body2,
                    ),
                  if (perspective.name != 'JUNTO' &&
                      perspective.name != 'Subscriptions' &&
                      perspective.about != null)
                    Text(
                      perspective.about,
                      style: Theme.of(context).textTheme.body2,
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
