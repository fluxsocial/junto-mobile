import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/pack.dart';
import 'package:junto_beta_mobile/providers/packs_provider/packs_provider.dart';
import 'package:junto_beta_mobile/screens/packs/pack_preview/pack_preview.dart';
import 'package:provider/provider.dart';


// This class renders the screen of packs a user belongs to
class JuntoPacks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        // My Pack
        const PackPreview(
          'The Gnarly Nomads',
          'Eric Yang',
          'assets/images/junto-mobile__eric.png',
        ),

        // Other Packs user belongs to
        Consumer<PacksProvider>(
          builder: (BuildContext context, PacksProvider packs, Widget child) {
            return ListView(
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              children: packs.packs
                  .map(
                    (Pack pack) => PackPreview(
                          pack.packTitle,
                          pack.packUser,
                          pack.packImage,
                        ),
                  )
                  .toList(),
            );
          },
        )
      ],
    );
  }
}
