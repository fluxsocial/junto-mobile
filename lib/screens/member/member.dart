import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/member/member_appbar/member_appbar.dart';

class JuntoMember extends StatelessWidget {
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
                // Den cover photo
                Container(
                  height: 150.0,
                  width: 1000,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: const AssetImage(
                        'assets/images/junto-mobile__stillmind.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Transform.translate(
                    offset: const Offset(0, 120),
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: <Widget>[
                                ClipOval(
                                  child: Image.asset(
                                    'assets/images/junto-mobile__eric.png',
                                    height: 60.0,
                                    width: 60.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                    color: Colors.transparent,
                    height: 30,
                    width: MediaQuery.of(context).size.width),

                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: const Color(0xffeeeeee),
                        width: 1,
                      ),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'Eric Yang',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xff333333),
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Text(
                                      'connect',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ]),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        margin: const EdgeInsets.only(top: 10, bottom: 10),
                        // color: Colors.blue,
                        width: MediaQuery.of(context).size.width,
                        child: const Text(
                          'To a mind that is still, the whole universe '
                          'surrenders - Lao Tzu. Houston-raised, NYC '
                          'based. ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom nav widget
      // bottomNavigationBar: BottomNav(),
    );
  }
}
