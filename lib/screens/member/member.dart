import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/components/gradient_outline_button/gradient_outline_button.dart';
import 'package:junto_beta_mobile/typography/palette.dart';
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
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 55),
                  decoration: BoxDecoration(
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

                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Eric Yang',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700)),
                          Text('sunyata',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14))
                        ],
                      )
                    ],
                  ),
                ),

                Container(
                    // color: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                    child: Row(
                      children: <Widget>[
                        Container(
                          // color: Colors.blue,
                          height: 33,
                          width: 99,
                          child: GradientOutlineButton(
                            strokeWidth: 2,
                            radius: 25,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xff5E54D0),
                                Color(0xff307FAB),
                              ],
                            ),
                            child: Image.asset(
                                'assets/images/junto-mobile__infinity.png',
                                height: 14),
                          ),
                        )
                      ],
                    )),

                Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Text(
                      "To a mind that is still, the whole universe surrenders",
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 15),
                    ))
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
