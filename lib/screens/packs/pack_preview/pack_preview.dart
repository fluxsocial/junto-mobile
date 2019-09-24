import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:junto_beta_mobile/screens/packs/pack_open/pack_open.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';

// This class renders a pack preview (usually shown in a list of packs)
class PackPreview extends StatelessWidget {
  const PackPreview(this.packTitle, this.packUser, this.packImage);

  final String packTitle;
  final String packUser;
  final String packImage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute<dynamic>(
            builder: (BuildContext context) => PackOpen(
              packTitle,
              packUser,
              packImage,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 10.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            ClipOval(
              child: Image.asset(
                packImage,
                height: 45.0,
                width: 45.0,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width - 65,
              padding: const EdgeInsets.symmetric(vertical: 20),
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
                  Text(packTitle,
                      textAlign: TextAlign.start, style: JuntoStyles.title),
                  Text(packUser,
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
