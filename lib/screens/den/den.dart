
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
        body: 


        Container(
          color: Colors.white,
          child: Column(
          children: <Widget>[
            // App bar border
            AppbarBorder(JuntoPalette.juntoGrey),

            // Den cover photo
            Container(
              height: 150.0,
              width: 1000,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/junto-mobile__den--photo.png'),
                  fit: BoxFit.cover)
              ),
              
              child: 
              Transform.translate(
                offset: Offset(0, 120),
                child: Container(
                  child: 
                    Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child:
                            
                              Row(children: [ClipOval(
                                child: Image.asset(
                                  'assets/images/junto-mobile__eric.png',
                                  height: 60.0,
                                  width: 60.0,
                                  fit: BoxFit.cover,
                                ),
                              ),]),
                                       
                          ),

                      ],
                    ),
                ),
              ),
              
              
              // Text('hello', style: TextStyle(fontSize: 24.0, color: Colors.white))
            ),

        Container(
          color: Colors.transparent,
          height: 30,
          width: MediaQuery.of(context).size.width
        ),  

        Container(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          color: Colors.white,
          width: MediaQuery.of(context).size.width,

          child: 
            Column(
              children: [
                Row(               
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ERIC YANG', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                        Text('sunyata', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,))          
                    ]),

                    Icon(Icons.edit, size: 14)
                  ]),

                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  // color: Colors.blue,
                  width: MediaQuery.of(context).size.width,
                  child: Text('To a mind that is still, the whole universe surrenders - Lao Tzu. Houston-raised, NYC based. ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,))
                ),

                Container(
                  // color: Colors.purple,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Text('EXPRESSIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xff333333)))
                      ),

                      Container(
                        child: Text('JOURNAL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xff777777)))
                      ),          


                      Container(
                        child: Text('FAVORITES', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xff777777)))
                      ),    

                      Container(
                        child: Text('DRAFTS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xff777777)))
                      ),                                  


                    ]              
                  )
                )
              ]),          
        ),          
 
          ],
        ),),


      



        // Bottom nav widget
        bottomNavigationBar: BottomNav(),

        
        );
  }
}
