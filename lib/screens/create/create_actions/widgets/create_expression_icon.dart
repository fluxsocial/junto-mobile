import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/expressions.dart';

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
    return Material(
      type: MaterialType.transparency,
      shape: const CircleBorder(side: BorderSide.none),
      child: Container(
        width: MediaQuery.of(context).size.width * .5 - 50,
        color: Colors.transparent,
        alignment: Alignment.center,
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
                  width: 50,
                  child: Icon(
                    expressionType.icon(),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 2.5),
                Text(
                  expressionType.name(),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    decoration: TextDecoration.none,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
