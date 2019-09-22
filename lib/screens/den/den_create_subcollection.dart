import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/palette.dart';
import 'package:junto_beta_mobile/styles.dart';
import 'package:junto_beta_mobile/custom_icons.dart';

class DenCreateSubcollection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(45),
          child: AppBar(
            automaticallyImplyLeading: false,
            brightness: Brightness.light,
            iconTheme: const IconThemeData(
              color: JuntoPalette.juntoSleek,
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            titleSpacing: 0,
            title: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: JuntoStyles.horizontalPadding),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      CustomIcons.back_arrow_left,
                      color: JuntoPalette.juntoSleek,
                      size: 24,
                    ),
                  ),
                  Text(
                    'Create subcollection',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff333333),
                        fontWeight: FontWeight.w700),
                  ),
                  GestureDetector(
                    onTap: () {
                      // create collection
                    },
                    child: const Text('create', style: JuntoStyles.body),
                  )
                ],
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: JuntoPalette.juntoFade,
              ),
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                children: <Widget>[SizedBox()],
              ),
            )
          ],
        ));
  }
}
