
import 'package:flutter/material.dart';

// typography + icons
import './../../typography/palette.dart';

// appbar + bottom nav
import '../../components/appbar/appbar.dart';
import '../../components/appbar/appbar_border/appbar_border.dart';
import './../../components/bottom_nav/bottom_nav.dart';

class JuntoDen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: JuntoAppBar.getJuntoAppBar('assets/images/junto-mobile__logo--den.png', 'DEN'),

        body: Column(
          children: <Widget>[
            // App bar border
            AppbarBorder(JuntoPalette.juntoGrey),

            // Den cover photo
            Container(
              height: 200.0,
              width: 1000,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/junto-mobile__den--photo.png'),
                  fit: BoxFit.cover)
              ),
              child: 
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15.0),
                  child: 
                    Column(
                      children: <Widget>[
                        Container(
                          // color: Colors.blue,
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(vertical: 15.0),
                          margin: EdgeInsets.symmetric(vertical: 15.0),
                          child:
                            Row(
                              children: <Widget>[
                              ClipOval(
                                child: Image.asset(
                                  'assets/images/junto-mobile__eric.png',
                                  height: 45.0,
                                  width: 45.0,
                                  fit: BoxFit.cover,
                                ),
                              ),

                              // profile name and handle
                              Container(
                                margin: EdgeInsets.only(left: 10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      'Eric Yang',
                                      style:
                                          TextStyle(fontSize: 14.0, fontWeight: FontWeight.w700, color: Colors.white),
                                    ),
                                    Text('@sunyata', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white))
                                  ],
                                ),
                              ),                                        
                            ],),
                          ),

                          // bio
                          Container(
                            margin: EdgeInsets.only(bottom: 15.0),
                            // color: Colors.green,
                            alignment: Alignment.centerLeft,
                            child: Text('"To a mind that is still, the whole universe surrenders"', 
                                        textAlign: TextAlign.left, style: TextStyle(color: Colors.white, fontSize: 14.0) )
                          )
                      ],
                    ),
                )
              
              
              // Text('hello', style: TextStyle(fontSize: 24.0, color: Colors.white))
            )      
          ],
        ),

        // Bottom nav widget
        bottomNavigationBar: BottomNav(),

        
        );
  }
}
