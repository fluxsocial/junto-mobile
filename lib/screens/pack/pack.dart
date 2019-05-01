
import 'package:flutter/material.dart';

import '../../components/appbar/appbar.dart';
import './../../components/bottom_nav/bottom_nav.dart';
import '../../models/pack.dart';
import './mypack__preview/mypack__preview.dart';
import './pack_preview.dart';
import './../../typography/palette.dart';

class JuntoPack extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {

    return _JuntoPackState();
  }
}

class _JuntoPackState extends State {
  List packs;

  @override
  void initState() {
    super.initState();

    packs = Pack.fetchAll();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
        appBar: JuntoAppBar.getJuntoAppBar('assets/images/junto-mobile__logo--pack.png', 'PACKS', JuntoPalette.juntoPurple),

        body:          
          ListView(
            children: <Widget>[
                          
              MyPackPreview(),
              
              ListView(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: packs.map((pack) => PackPreview(pack.packTitle, pack.packUser)).toList()
                )              
            ],
          ),
        bottomNavigationBar: BottomNav());
  }
}
