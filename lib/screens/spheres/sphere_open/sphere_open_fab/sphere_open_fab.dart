
import 'package:flutter/material.dart';
import '../../../../typography/palette.dart';
import '../../../../custom_icons.dart';
import '../../../create/create.dart';

class SphereOpenFAB extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return 
      AnimatedOpacity(                                      
        duration: Duration(milliseconds: 200),          
        opacity: 1,
        child: GestureDetector(
            onTap:() {
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder:(context, animation, secondaryAnimation) {
                    return JuntoCreate();
                  },
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },

                  transitionDuration: Duration(milliseconds: 200)        
                )                       
              );
            },
          child: 
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.7),
              border: Border.all(
                color: Colors.blue,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: Icon(CustomIcons.lotus, color: Colors.blue),),
      ));    
  }
}