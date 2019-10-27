import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';

/// Gradient [FloatingActionButton] used for filtering
/// Collectives.
class ExpressionCenterFAB extends StatelessWidget {
  const ExpressionCenterFAB({Key key, @required this.expressionLayer})
      : super(key: key);

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
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: const <double>[0.1, 0.9],
              colors: <Color>[
                JuntoPalette.juntoSecondary,
                JuntoPalette.juntoPrimary,
              ],
            ),
            color: JuntoPalette.juntoWhite.withOpacity(.9),
            border: Border.all(color: JuntoPalette.juntoWhite, width: 2),
            borderRadius: BorderRadius.circular(100),
          ),
          alignment: Alignment.center,
          child: const Icon(CustomIcons.enso, color: Colors.white, size: 20)),
    );
  }
}
