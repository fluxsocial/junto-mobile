import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './pack_preview/pack_preview.dart';
import '../../scoped_models/scoped_user.dart';

// This class renders the screen of packs a user belongs to
class JuntoPacks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        // My Pack
        PackPreview('The Gnarly Nomads', 'Eric Yang', 'assets/images/junto-mobile__eric.png'),
        
        // Other Packs user belongs to
            // ListView(
            //     physics: ClampingScrollPhysics(),
            //     shrinkWrap: true,
            //     children: model.packs
            //         .map((pack) => PackPreview(pack.packTitle, pack.packUser, pack.packImage))
            //         .toList())
      ]);
  }
}
