import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';

/// Gradient [FloatingActionButton] used for filtering
/// Collectives.
class CreateFAB extends StatelessWidget {
  const CreateFAB({Key key, @required this.expressionLayer}) : super(key: key);

  final String expressionLayer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder<dynamic>(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return JuntoCreate(
              expressionLayer,
            );
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(
            milliseconds: 200,
          ),
        ),
      ),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          gradient:  LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: const <double>[0.3, 0.9],
            colors: <Color>[
              // JuntoPalette.juntoSecondary,
              JuntoPalette.juntoPrimary,
              Color(0xFFFFCF68)
            ],
          ),
          color: JuntoPalette.juntoWhite.withOpacity(.9),
          border: Border.all(
            color: JuntoPalette.juntoWhite,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        alignment: Alignment.center,
        child: const Icon(CustomIcons.enso, color: Colors.white, size: 28)
      ),
    );
  }
}
