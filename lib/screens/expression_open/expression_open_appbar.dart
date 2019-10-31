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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                color: Colors.transparent,
                width: 42,
                alignment: Alignment.centerLeft,
                child: Icon(
                  CustomIcons.back,
                  color: JuntoPalette.juntoGrey,
                  size: 17,
                ),
              ),
            ),

            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return ExpressionOpenContext();
                  },
                );
              },
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(right: 10),
                width: 42,
                alignment: Alignment.centerRight,
                child: const Icon(
                  CustomIcons.enso,
                  size: 20,
                  color: Color(0xff333333),
                ),
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

class ExpressionOpenContext extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff737373),
      child: Container(
        height: MediaQuery.of(context).size.height * .5,
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
            Text(
              'CONTEXT',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xff555555),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 38.0,
                  width: 38.0,
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
                  child: const Icon(
                    CustomIcons.enso,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "shared to 'Collective'",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff333333),
                  ),
                )
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  height: 38.0,
                  width: 38.0,
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
                  child: Icon(
                    CustomIcons.hash,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'tagged in #sustainability, #permaculture, #design',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xff333333),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'INTENTION',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff555555)),
            ),
            const SizedBox(height: 10),
            Text(
              'Looking for feedback!',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}
