import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:junto_beta_mobile/screens/den/den_collection_open.dart';

class DenCollectionPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute<dynamic>(
            builder: (BuildContext context) => DenCollectionOpen(),
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xffeeeeee),
              width: .75,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  'assets/images/junto-mobile__collection.png',
                  height: 20,
                  color: const Color(0xff555555),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Text(
                      'Anbu',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: 5),
                    Text('7 expressions')
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
