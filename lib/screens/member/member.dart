import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/models/user_model.dart';
import 'package:junto_beta_mobile/screens/member/member_appbar.dart';
import 'package:junto_beta_mobile/screens/member/member_expanded.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class JuntoMember extends StatefulWidget {
  const JuntoMember({
    Key key,
    @required this.profile,
  }) : super(key: key);

  static Route<dynamic> route(UserProfile profile) {
    return CupertinoPageRoute<dynamic>(
      builder: (BuildContext context) {
        return JuntoMember(
          profile: profile,
        );
      },
    );
  }

  final UserProfile profile;

  @override
  _JuntoMemberState createState() => _JuntoMemberState();
}

class _JuntoMemberState extends State<JuntoMember> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: MemberAppbar(widget.profile.username),
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
                                  handle: widget.profile.username,
                                  name: '${widget.profile.firstName} '
                                      '${widget.profile.lastName}',
                                  profilePicture:
                                      'assets/images/junto-mobile__placeholder--member.png',
                                  bio: widget.profile.bio,
                                ),
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
                                'assets/images/junto-mobile__placeholder--member.png',
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
                                builder: (BuildContext context) => Container(
                                  color: const Color(0xff737373),
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height * .4,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Container(
                                                  height: 5,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      .1,
                                                  decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xffeeeeee),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100)),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            ListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              title: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.visibility,
                                                    size: 17,
                                                    color:
                                                        const Color(0xff555555),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  const Text(
                                                    'Subscribe',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              title: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    CustomIcons.circle,
                                                    size: 17,
                                                    color:
                                                        const Color(0xff555555),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  const Text(
                                                    'Connect',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            ListTile(
                                              contentPadding:
                                                  const EdgeInsets.all(0),
                                              onTap: () {},
                                              title: Row(
                                                children: <Widget>[
                                                  Icon(
                                                    CustomIcons.packs,
                                                    size: 17,
                                                    color:
                                                        const Color(0xff555555),
                                                  ),
                                                  const SizedBox(width: 15),
                                                  const Text(
                                                    'Join Pack',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 17),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: FlatButton(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text(
                                              'Cancel',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            color: const Color(0xffeeeeee),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                          ),
                                        )
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
                          '${widget.profile.firstName} ${widget.profile.lastName}',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 10),
                        Text(widget.profile.bio,
                            style: const TextStyle(fontSize: 15)),
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
                                    'Somewhere cool',
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
                            ),
                          ],
                        ),
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
