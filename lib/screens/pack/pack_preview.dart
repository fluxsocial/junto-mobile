
import 'package:flutter/material.dart';

class PackPreview extends StatelessWidget {
  final String packTitle;
  final String packUser;

  PackPreview(this.packTitle, this.packUser);

  @override
  Widget build(BuildContext context) {

    return 
            // My Pack
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
                    // crossAxisAlignment: CrossAxisAlignment.center,
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
                            Text(packTitle, textAlign: TextAlign.start,),
                            Text(packUser, textAlign: TextAlign.start,)
                          ],
                        ),)
                  ],),

                ],
              )

            );    
  }

}