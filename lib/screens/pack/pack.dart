import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './pack_preview.dart';
import '../../scoped_models/scoped_user.dart';

class JuntoPack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        PackPreview('The Gnarly Nomads', 'Eric Yang'),
        ScopedModelDescendant<ScopedUser>(
            builder: (context, child, model) => ListView(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                children: model.packs
                    .map((pack) => PackPreview(pack.packTitle, pack.packUser))
                    .toList()))
      ],
    );
  }
}
