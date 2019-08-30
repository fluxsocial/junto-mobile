import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:junto_beta_mobile/screens/member/member.dart';
import 'package:junto_beta_mobile/screens/welcome/welcome.dart';
import 'package:junto_beta_mobile/typography/palette.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open.dart';
import 'package:junto_beta_mobile/screens/den/den_settings/den_settings.dart';
import 'package:junto_beta_mobile/screens/den/den_connections/den_connections.dart';
import 'package:junto_beta_mobile/screens/den/den_followers/den_followers.dart';

/// Displays the user's DEN or "profile screen"
class JuntoDen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => JuntoDenState();
}

class JuntoDenState extends State<JuntoDen> {
  void noNav() {
    return;
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 55),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                        stops: <double>[0.1, 0.9],
                        colors: <Color>[Color(0xff5E54D0), Color(0xff307FAB)])),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                        border: Border.all(
                          width: 3.0,
                          color: Colors.white,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/junto-mobile__eric.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Eric Yang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Color(0xffeeeeee), width: 1),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => DenFollowers(),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/junto-mobile__outlinelogo--gradient.png',
                              height: 17,
                              color: const Color(0xff555555),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Followers',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff555555),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => DenConnections(),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/junto-mobile__infinity.png',
                              height: 17,
                              color: const Color(0xff555555),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Connections',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff555555),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => const PackOpen(
                                'The Gnarly Nomads',
                                'sunyata',
                                'assets/images/junto-mobile__eric.png'),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Image.asset(
                              'assets/images/junto-mobile__join-pack.png',
                              height: 17,
                              color: const Color(0xff555555),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'My Pack',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff555555),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => DenSettings(),
                          ),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const <Widget>[
                            Icon(CustomIcons.more, size: 17),
                            SizedBox(height: 5),
                            Text(
                              'Settings',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff555555),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
                child: const Text(
                  'To a mind that is still, the whole universe surrenders',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(right: 15),
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/junto-mobile__location.png',
                              height: 17,
                              color: const Color(0xff555555),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'Spirit',
                              style: TextStyle(
                                color: Color(0xff555555),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Row(
                          children: <Widget>[
                            Image.asset(
                              'assets/images/junto-mobile__link.png',
                              height: 17,
                              color: const Color(0xff555555),
                            ),
                            const SizedBox(width: 5),
                            const Text(
                              'junto.foundation',
                              style: TextStyle(color: JuntoPalette.juntoBlue),
                            )
                          ],
                        ),
                      )
                    ],
                  )),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: const Text(
                        'EXPRESSIONS',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    )
                  ],
                ),
              ),
              RaisedButton(onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => JuntoMember(),
                  ),
                );
              }),
              RaisedButton(
                onPressed: () async {
                  await FlutterSecureStorage().write(
                    key: 'isLogged'
                        'In',
                    value: 'false',
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => Welcome(),
                    ),
                  );
                },
                color: const Color(0xff4968BF),
                child: const Text(
                  'LOG OUT',
                  style: TextStyle(
                    // color: JuntoPalette.juntoBlue,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    100,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
