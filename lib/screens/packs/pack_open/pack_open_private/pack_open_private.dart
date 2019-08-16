
import 'package:flutter/material.dart';

class PackOpenPrivate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('private'));
      // expressions
      // ScopedModelDescendant<ScopedUser>(
      //     builder: (context, child, model) => ListView(
      //           shrinkWrap: true,
      //           physics: ClampingScrollPhysics(),
      //           children: model.denExpressions
      //               .map(
      //                   (expression) => ExpressionPreview(expression))
      //               .toList(),
      //         ));    
  }
}