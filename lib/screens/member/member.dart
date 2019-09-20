import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/screens/member/member_appbar.dart';
import 'package:junto_beta_mobile/screens/member/member_expanded.dart';
import 'package:junto_beta_mobile/palette.dart';

class JuntoMember extends StatelessWidget {
  // placeholder member details
  final String memberHandle = 'sunyata';
  final String memberName = 'Eric Yang';
  final String memberProfilePicture = 'assets/images/junto-mobile__eric.png';
  final String memberBio = 'on the vibe';
  final String memberLocation = 'Spirit';
  final String memberWebsite = 'junto.foundation';

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(45),
        child: MemberAppbar('sunyata'),
      ),
      backgroundColor: Colors.white,
      body: ListView(
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    MemberExpanded(
                                        handle: memberHandle,
                                        name: memberName,
                                        profilePicture: memberProfilePicture,
                                        bio: memberBio),
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
                                width: 3,
                                color: Colors.white,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                memberProfilePicture,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Transform.translate(
                          offset: const Offset(0.0, 9.0),
                          child: GestureDetector(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                  color: Color(0xff737373),
                                  child: Container(
                                    height: 240,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        ListTile(
                                          title: Text('Follow'),
                                        ),
                                        ListTile(
                                          title: Text('Connect'),

                                        ),
                                        ListTile(
                                          title: Text('Join Pack'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7.5),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: JuntoPalette.juntoGrey, width: 1),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(width: 14),
                                  Image.asset(
                                      'assets/images/junto-mobile__infinity.png',
                                      height: 14),
                                  const SizedBox(width: 2),
                                  Icon(Icons.keyboard_arrow_down, size: 12)
                                ],
                              ),
                            ),
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
                          memberName,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        Text(memberBio, style: const TextStyle(fontSize: 15)),
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
                                    Text(
                                      memberLocation,
                                      style: const TextStyle(
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
                                    Text(
                                      memberWebsite,
                                      style: const TextStyle(
                                          color: JuntoPalette.juntoPrimary),
                                    )
                                  ],
                                ),
                              )
                            ]),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
