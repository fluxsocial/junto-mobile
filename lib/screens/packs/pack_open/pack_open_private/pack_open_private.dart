
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/rendering.dart';

import './../pack_open_appbar/pack_open_appbar.dart';
import '../../../../scoped_models/scoped_user.dart';
import '../../../../components/expression_preview/expression_preview.dart';
import '../../../../custom_icons.dart';
import '../../../../typography/palette.dart';

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