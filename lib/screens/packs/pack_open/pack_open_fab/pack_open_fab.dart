import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/palette.dart';

class PackOpenFAB extends StatelessWidget {
  const PackOpenFAB({Key key, this.isVisible}) : super(key: key);

  final ValueNotifier<bool> isVisible;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: isVisible,
        builder: (BuildContext context, bool value, _) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: value ? 1 : 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                // border: Border.all(color: Color(0xffeeeeee), width: .5),
                borderRadius: BorderRadius.circular(25),
                boxShadow: const <BoxShadow>[
                  BoxShadow(
                    color: JuntoPalette.juntoGreyLight,
                    blurRadius: 3,
                    offset: Offset(1, 2),
                  )
                ],
              ),
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              // padding: EdgeInsets.symmetric(vertical: 15),
              height: 50,
              width: MediaQuery.of(context).size.width * .5,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * .25,
                    child: Icon(
                      CustomIcons.half_lotus,
                      size: 17,
                      color: JuntoPalette.juntoGrey,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * .25,
                    child: RotatedBox(
                      quarterTurns: 2,
                      child: Icon(
                        CustomIcons.triangle,
                        size: 17,
                        color: JuntoPalette.juntoGrey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
