import 'package:flutter/material.dart';

import './../../custom_icons.dart';
import './../../screens/collective.dart';
import './../../screens/spheres.dart';
import './../../screens/pack.dart';
import './../../screens/den.dart';

class BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return 
        Container(
          height: 45,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton( 
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => JuntoCollective()),
                  );
                },
                icon: Icon(CustomIcons.home, size: 24.0,),
                color: Colors.black),

              IconButton(     
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => JuntoSpheres()),
                  );
                },
                icon: Icon(CustomIcons.home, size: 24.0,),
                color: Colors.black),

              IconButton(       
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => JuntoCollective()),
                  );
                },
                icon: Icon(CustomIcons.home, size: 24.0,),
                color: Colors.black),

              IconButton(    
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => JuntoPack()),
                  );
                },
                icon: Icon(CustomIcons.home, size: 24.0,),
                color: Colors.black),

              IconButton(         
                padding: EdgeInsets.all(0.0),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => JuntoDen()),
                  );
                },
                icon: Icon(CustomIcons.home, size: 24.0,),
                color: Colors.black),                                                                
        
            ],
          )
        );

       
          
    }
}
