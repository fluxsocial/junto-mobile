import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';
import 'package:junto_beta_mobile/app/themes_provider.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:provider/provider.dart';

typedef OnCreateExpressionTap = void Function(
    BuildContext context, ExpressionType expression);

class CreateExpressionIcon extends StatelessWidget {
  const CreateExpressionIcon({
    Key key,
    @required this.onTap,
    @required this.expressionType,
  }) : super(key: key);

  final OnCreateExpressionTap onTap;
  final ExpressionType expressionType;

  @override
  Widget build(BuildContext context) {
    return Consumer<JuntoThemesProvider>(
        builder: (BuildContext context, JuntoThemesProvider theme, child) {
      return Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(side: BorderSide.none),
        child: Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(
            right: 15,
            left: 15,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => onTap(context, expressionType),
            highlightColor: Colors.white10,
            splashColor: Colors.white10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    height: 40,
                    child: Icon(
                      expressionType.icon(),
                      color: JuntoPalette().juntoWhite(theme: theme),
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    expressionType.name(),
                    style: TextStyle(
                      fontSize: 12,
                      color: JuntoPalette().juntoWhite(theme: theme),
                      fontWeight: FontWeight.w700,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
