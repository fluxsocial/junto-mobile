import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/screens/member/member_appbar/member_appbar.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';

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
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          // SizedBox(width: 20),
                          Container(
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
                                'assets/images/junto-mobile__eric.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Transform.translate(
                              offset: const Offset(0.0, 9.0),
                              child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 7.5),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: JuntoPalette.juntoGrey,
                                          width: 1),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: <Widget>[
                                      SizedBox(width: 14),

                                      Image.asset(
                                          'assets/images/junto-mobile__infinity.png',
                                          height: 14),
                                          SizedBox(width: 2),
                                      Icon(Icons.keyboard_arrow_down, size: 12)
                                    ],
                                  ))

                              // Container(
                              //   height: 36,
                              //   child: Row(
                              //     crossAxisAlignment: CrossAxisAlignment.center,
                              //     mainAxisAlignment:
                              //         MainAxisAlignment.spaceBetween,
                              //     children: <Widget>[
                              //       Container(
                              //         child: Column(
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.center,
                              //           children: <Widget>[
                              //             Image.asset(
                              //               'assets/images/junto-mobile__outlinelogo--gradient.png',
                              //               height: 17,
                              //               color: JuntoPalette.juntoSleek,
                              //             ),
                              //             const SizedBox(height: 5),
                              //             const Text(
                              //               'Follow',
                              //               style: TextStyle(
                              //                 fontSize: 12,
                              //                 color: JuntoPalette.juntoSleek,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       SizedBox(width: 45),
                              //       Container(
                              //         child: Column(
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.center,
                              //           children: <Widget>[
                              //             Image.asset(
                              //               'assets/images/junto-mobile__infinity.png',
                              //               height: 17,
                              //               color: JuntoPalette.juntoSleek,
                              //             ),
                              //             const SizedBox(height: 5),
                              //             const Text(
                              //               'Connect',
                              //               style: TextStyle(
                              //                 fontSize: 12,
                              //                 color: JuntoPalette.juntoSleek,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //       SizedBox(width: 45),

                              //       Container(
                              //         child: Column(
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.center,
                              //           children: <Widget>[
                              //             Image.asset(
                              //               'assets/images/junto-mobile__join-pack.png',
                              //               height: 17,
                              //               color: JuntoPalette.juntoSleek,
                              //             ),
                              //             const SizedBox(height: 5),
                              //             const Text(
                              //               'Join Pack',
                              //               style: TextStyle(
                              //                 fontSize: 12,
                              //                 color: JuntoPalette.juntoSleek,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              )
                        ],
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0.0, -18.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Eric Yang',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w700),
                          ),
                          SizedBox(height: 10),
                          Text(
                              '"To a mind that is still, the whole universe surrenders."',
                              style: TextStyle(fontSize: 15)),
                          SizedBox(height: 10),
                          Row(
                              // mainAxisAlignment: MainAxisAlignment.center,
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
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
