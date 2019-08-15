import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:junto_beta_mobile/providers/packs_provider/packs_provider.dart';
import './pack_preview/pack_preview.dart';

// This class renders the screen of packs a user belongs to
class JuntoPacks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(children: <Widget>[
      // My Pack
      PackPreview('The Gnarly Nomads', 'Eric Yang',
          'assets/images/junto-mobile__eric.png'),

      // Other Packs user belongs to
      Consumer<PacksProvider>(builder: (context, packs, child) {
        return ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            children: packs.packs
                .map((pack) =>
                    PackPreview(pack.packTitle, pack.packUser, pack.packImage))
                .toList());
      })
    ]);
  }
}
