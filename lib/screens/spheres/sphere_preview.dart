
import 'package:flutter/material.dart';

class SpherePreview extends StatelessWidget {
  final String sphereTitle;
  final String sphereMembers;

  SpherePreview(this.sphereTitle, this.sphereMembers);

  @override
  Widget build(BuildContext context) {

    return 
            Container(
              height: 90.0,
              padding: EdgeInsets.symmetric(horizontal: 17.0),
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
                            Text(sphereTitle, textAlign: TextAlign.start,),
                            Text(sphereMembers + ' members', textAlign: TextAlign.start,)
                          ],
                        ),)
                  ],),

                ],
              )

            );        
  }
}