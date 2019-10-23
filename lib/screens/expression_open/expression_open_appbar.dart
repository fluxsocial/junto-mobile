import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';

class ExpressionOpenAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      brightness: Brightness.light,
      iconTheme: const IconThemeData(color: JuntoPalette.juntoSleek),
      backgroundColor: Colors.white,
      elevation: 0,
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  color: Colors.white,
                  width: 38,
                  alignment: Alignment.centerLeft,
                  child: const Icon(
                    CustomIcons.back_arrow_left,
                    color: JuntoPalette.juntoSleek,
                    size: 28,
                  ),
                )),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      color: const Color(0xff737373),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .9,
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const SizedBox(height: 10),
                            Row(
                              children: const <Widget>[
                                Text(
                                  'Expression context',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff333333),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'This will show the context of each expression, and the icon that you pressed to open this modal up will be dynamic. For example, for a given expression this would show that it resides in the collective and is tagged into channels x, y, z.'
                              ' Expressions that live in the collective context will have the collective icon (tbd). Those that live in spheres, pack, den will reflect the icons that represent those contexts as well. Hope this makes sense!',
                              style: TextStyle(fontSize: 15, height: 1.4),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                color: Colors.white,
                width: 32,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 10),
                child: const Icon(CustomIcons.half_lotus, size: 14),
              ),
            )
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: <double>[0.1, 0.9],
              colors: <Color>[
                JuntoPalette.juntoFade,
                JuntoPalette.juntoFade,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
