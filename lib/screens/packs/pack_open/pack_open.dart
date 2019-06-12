import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './pack_open_appbar/pack_open_appbar.dart';
import '../../../scoped_models/scoped_user.dart';
import '../../../components/expression_preview/expression_preview.dart';

class PackOpen extends StatefulWidget {
  final packTitle;
  final packUser;
  final packImage;

  PackOpen(this.packTitle, this.packUser, this.packImage);

  @override
  State<StatefulWidget> createState() {
    return PackOpenState();
  }
}

class PackOpenState extends State<PackOpen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(45.0),
        child: PackOpenAppbar(widget.packTitle, widget.packUser, widget.packImage)
      ),
      
            body: ScopedModelDescendant<ScopedUser>(
        builder: (context, child, model) => ListView(
              // shrinkWrap: true,
              // physics: ClampingScrollPhysics(),
              children: model.collectiveExpressions
                  .map((expression) => ExpressionPreview(expression))
                  .toList(),
            ),
      ),
    );
  }
}
