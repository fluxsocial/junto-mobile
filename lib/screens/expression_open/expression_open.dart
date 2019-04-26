
import 'package:flutter/material.dart';

import '../../components/appbar/appbar_border/appbar_border.dart';
import '../../typography/palette.dart';
import '../../typography/style.dart';
import '../../custom_icons.dart';
import '../../components/bottom_nav/bottom_nav.dart';

class ExpressionOpen extends StatelessWidget {
  final expression;

  ExpressionOpen(this.expression);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: 
      PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: 
          AppBar(            
            automaticallyImplyLeading: false,
            brightness: Brightness.light,
            iconTheme: IconThemeData(color: JuntoPalette.juntoSleek),
            backgroundColor: Colors.white,
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(CustomIcons.back_arrow_left, color: JuntoPalette.juntoSleek, size: 20),
                  ),
                  Icon(Icons.bookmark_border, color: JuntoPalette.juntoSleek, size: 20)

            ],
          ),
      ),),

      
      body: Container(child:
        Column(
          children: <Widget>[
            AppbarBorder(JuntoPalette.juntoSleek),

            // Container(
            //   child: 
            //     Row(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: <Widget>[
                  
            //       // profile picture
            //       ClipOval(
            //         child: Image.asset(
            //           'assets/images/junto-mobile__eric.png',
            //           height: 36.0,
            //           width: 36.0,
            //           fit: BoxFit.cover,
            //         ),
            //       ),

            //       // profile name and handle
            //       Container(
            //         margin: EdgeInsets.only(left: 10.0),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: <Widget>[
            //             Text(
            //               'Eric Yang',
            //               style: JuntoStyles.expressionPreviewName,
            //             ),
            //             Text('sunyata', style: JuntoStyles.expressionPreviewHandle)
            //           ],
            //         ),
            //       ),
            //     ]),              
            // ),

            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              color: Colors.blue,
              child: Text('expression', style:TextStyle(color: Colors.white))

            ),

            Container(
              height: 75,
              width: MediaQuery.of(context).size.width,
              color: Colors.purple,
              child: Text('action items', style:TextStyle(color: Colors.white))

            ),            


          
          ],
        )      
      ),

      // bottomNavigationBar: BottomNav(),
    );
  }
}