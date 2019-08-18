import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';

// This widget is a Floating Action Button
class CreateFAB extends StatelessWidget {
  const CreateFAB(this.sphereHandle);

  final String sphereHandle;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 200),
      opacity: 1,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder<dynamic>(
              pageBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return JuntoCreate(sphereHandle);
              },
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) {
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
      ),
    );
  }
}
