import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/typography/palette.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/screens/member/member_appbar/member_appbar.dart';

class JuntoMember extends StatelessWidget {
  // placeholder location
  final String _memberLocation = 'Spirit';

  // placeholder website
  final String _memberWebsite = 'junto.foundation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 55),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          stops: <double>[
                        0.1,
                        0.9
                      ],
                          colors: <Color>[
                        Color(0xff5E54D0),
                        Color(0xff307FAB)
                      ])),
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
                      Text(
                        'Eric Yang',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700),
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
                      Container(
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
                              'Follow',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff555555),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
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
                              'Connect',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff555555),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
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
                              'Join Pack',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff555555),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(CustomIcons.more, size: 17),
                            const SizedBox(height: 5),
                            const Text(
                              'More',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff555555),
                              ),
                            ),
                          ],
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
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
                              Text(
                                _memberLocation,
                                style: const TextStyle(
                                  color: Color(0xff555555),

                                ),
                              ),
                            ],
                          ),
                        ),
                        _memberWebsite != ''
                            ? Container(
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'assets/images/junto-mobile__link.png',
                                      height: 17,
                                      color: const Color(0xff555555),
                                    ),

                                    const SizedBox(width: 5),
                                    Text(
                                      _memberWebsite,
                                      style: TextStyle(
                                          color: JuntoPalette.juntoBlue),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox()
                      ],
                    )),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      Container(
                        child: Text(
                          'EXPRESSIONS',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
