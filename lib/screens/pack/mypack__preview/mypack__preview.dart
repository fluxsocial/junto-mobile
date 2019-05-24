
import 'package:flutter/material.dart';

class MyPackPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return 
      Container(
        height: 75.0,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        color: Colors.white,
        foregroundDecoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: .75, color: Color(0xffeeeeee)),
          ),
        ),              
        child: Row(
          children: <Widget>[
            Row(
              children: <Widget>[
                ClipOval(                                                                        
                    child: Image.asset(
                      'assets/images/junto-mobile__eric.png',
                      height: 36.0,
                      width: 36.0,
                      fit: BoxFit.cover,                            
                    ),
                  ),                    

                Container(
                  margin: EdgeInsets.only(left: 10.0),
                  child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('The Gnarly Nomads', textAlign: TextAlign.start,),
                      Text('Eric Yang', textAlign: TextAlign.start,)
                    ],
                  ),)
            ],),

          ],
        )

      ); 
  }

}