import 'package:flutter/material.dart'; 
import 'package:junto_beta_mobile/custom_icons.dart'; 
import 'package:junto_beta_mobile/screens/create/create.dart'; 

// This widget is a Floating Action Button
class CreateFAB extends StatelessWidget {
  final sphereHandle;

  CreateFAB(this.sphereHandle);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
        duration: Duration(milliseconds: 200),
        opacity: 1,
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) {
                  return JuntoCreate(sphereHandle);
                },
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
                transitionDuration: Duration(milliseconds: 200),
              ),
            );
          },
          child: Container(
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
            child: Icon(CustomIcons.lotus, color: Colors.blue),
          ),
        ));
  }
}
