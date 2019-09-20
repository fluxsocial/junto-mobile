import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/providers/provider.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/screens/den/den_expanded.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/palette.dart';

/// Displays the user's DEN or "profile screen"
class JuntoDen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => JuntoDenState();
}

class JuntoDenState extends State<JuntoDen> {
  String handle = 'sunyata';
  String name = 'Eric Yang';
  String profilePicture = 'assets/images/junto-mobile__eric.png';
  String bio = 'on the vibe';

  bool publicExpressionsActive = true;
  bool publicCollectionActive = false;
  bool privateExpressionsActive = true;
  bool privateCollectionActive = false;

  void noNav() {
    return;
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   _retrieveUserInfo();
  // }

  // Future<void> _retrieveUserInfo() async {
  //   final UserProvider _userProvider = Provider.of<UserProvider>(context);
  //   try {
  //     final UserProfile _profile = await _userProvider.readLocalUser();
  //     setState(() {
  //       handle = _profile.username;
  //       name = '${_profile.firstName} ${_profile.lastName}';
  //       bio = _profile.bio;
  //     });
  //   } catch (error) {
  //     debugPrint('Error occured in _retrieveUserInfo: $error');
  //   }
  // }

  _togglePublicDomain(domain) {
    if (domain == 'expressions') {
      setState(() {
        publicExpressionsActive = true;
        publicCollectionActive = false;
      });
    } else if (domain == 'collection') {
      setState(() {
        publicExpressionsActive = false;
        publicCollectionActive = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * .2,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      stops: <double>[
                        0.1,
                        0.9
                      ],
                      colors: <Color>[
                        JuntoPalette.juntoSecondary,
                        JuntoPalette.juntoPrimary
                      ]),
                ),
              ),
              Transform.translate(
                offset: const Offset(0.0, -18.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      // SizedBox(width: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute<dynamic>(
                              builder: (BuildContext context) => DenExpanded(
                                  handle: handle,
                                  name: name,
                                  profilePicture: profilePicture,
                                  bio: bio),
                            ),
                          );
                        },
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue,
                            border: Border.all(
                              width: 2.0,
                              color: Colors.white,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              profilePicture,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: const Offset(0.0, 9.0),
                        child: GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          child: Icon(CustomIcons.more, size: 24),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Transform.translate(
                offset: const Offset(0.0, -18.0),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 10),
                      Text(bio, style: const TextStyle(fontSize: 15)),
                      const SizedBox(height: 10),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(right: 15),
                              child: Row(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/junto-mobile__location.png',
                                    height: 17,
                                    color: JuntoPalette.juntoSleek,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    'Spirit',
                                    style: TextStyle(
                                      color: JuntoPalette.juntoSleek,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              child: Row(
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/junto-mobile__link.png',
                                    height: 17,
                                    color: JuntoPalette.juntoSleek,
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    'junto.foundation',
                                    style: TextStyle(
                                        color: JuntoPalette.juntoPrimary),
                                  )
                                ],
                              ),
                            )
                          ]),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xffeeeeee),
                      width: .75,
                    ),
                    // top: BorderSide(color: Color(0xffeeeeee), width: .75),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(right: 15),
                          child: const Text(
                            'Public Den',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Container(
                          child: const Text(
                            'Private Den',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(2.5),
                          height: 30,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Color(0xfffeeeeee),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  _togglePublicDomain('expressions');
                                },
                                child: Container(
                                  height: 30,
                                  // half width of parent container minus horizontal padding
                                  width: 37.5,
                                  decoration: BoxDecoration(
                                    color: publicExpressionsActive
                                        ? Colors.white
                                        : Color(0xffeeeeee),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Icon(
                                    CustomIcons.half_lotus,
                                    size: 12,
                                    color: publicExpressionsActive
                                        ? Color(0xff555555)
                                        : Color(0xff999999),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  _togglePublicDomain('collection');
                                },
                                child: Container(
                                  height: 30,
                                  // half width of parent container minus horizontal padding
                                  width: 37.5,
                                  decoration: BoxDecoration(
                                    color: publicCollectionActive
                                        ? Colors.white
                                        : Color(0xffeeeeee),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Icon(
                                    Icons.collections,
                                    size: 12,
                                    color: publicCollectionActive
                                        ? Color(0xff555555)
                                        : Color(0xff999999),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        publicCollectionActive
                            ? Row(
                                children: <Widget>[
                                  Text('create a collection',
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)),
                                  SizedBox(width: 5),
                                  Icon(Icons.add, size: 14)
                                ],
                              )
                            : SizedBox()
                      ],
                    )
                  ],
                ),
              ),

              // RaisedButton(
              //   onPressed: () async {
              //     await Provider.of<AuthenticationProvider>(context)
              //         .logoutUser();
              //     Navigator.pushReplacement(
              //       context,
              //       MaterialPageRoute<dynamic>(
              //         builder: (BuildContext context) => Welcome(),
              //       ),
              //     );
              //   },
              //   color: const Color(0xff4968BF),
              //   child: const Text(
              //     'LOG OUT',
              //     style: TextStyle(
              //       // color: JuntoPalette.juntoBlue,
              //       color: Colors.white,
              //       fontWeight: FontWeight.w700,
              //       fontSize: 14,
              //     ),
              //   ),
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.circular(
              //       100,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
