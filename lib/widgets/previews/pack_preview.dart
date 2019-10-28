import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/models/group_model.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/app/styles.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

// This class renders a pack preview (usually shown in a list of packs)
class PackPreview extends StatelessWidget {
  const PackPreview({Key key, @required this.group}) : super(key: key);

  final Group group;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute<dynamic>(
            builder: (BuildContext context) => PackOpen(
              pack: group,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              height: 45.0,
              width: 45.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  stops: const <double>[0.3, 0.9],
                  colors: <Color>[
                    JuntoPalette.juntoSecondary,
                    JuntoPalette.juntoPrimary,
                  ],
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Transform.translate(
                offset: Offset(-1.0, 0),
                child: Icon(
                  CustomIcons.packs,
                  color: Colors.white,
                  size: 17,
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 75,
              padding: const EdgeInsets.symmetric(vertical: 15),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: .5, color: JuntoPalette.juntoFade),
                ),
              ),
              margin: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    group.groupData.name,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  Text(group.creator,
                      textAlign: TextAlign.start, style: JuntoStyles.body),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
