import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/palette.dart';

class CreateBottomNav extends StatelessWidget {
  const CreateBottomNav(this.switchTemplate, this.bottomNavVisible);

  final Function switchTemplate;
  final bool bottomNavVisible;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: bottomNavVisible ? 90 : 45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          bottomNavVisible
              ? Container(
                  alignment: Alignment.center,
                  height: 45.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          switchTemplate('LongForm');
                        },
                        child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width * .25,
                          child: const Icon(
                            CustomIcons.longform,
                            size: 20,
                            color: JuntoPalette.juntoBlack,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          switchTemplate('ShortForm');
                        },
                        child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width * .25,
                          child: const Icon(
                            CustomIcons.feather,
                            size: 20,
                            color: JuntoPalette.juntoBlack,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          switchTemplate('PhotoForm');
                        },
                        child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width * .25,
                          child: const Icon(
                            CustomIcons.camera,
                            size: 20,
                            color: JuntoPalette.juntoBlack,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          switchTemplate('EventForm');
                        },
                        child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width * .25,
                          child: const Icon(
                            CustomIcons.event,
                            size: 20,
                            color: JuntoPalette.juntoBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
          Container(
            alignment: Alignment.center,
            height: 45,
            color: Colors.white,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                CustomIcons.lotus,
                color: JuntoPalette.juntoPrimary,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// GestureDetector(
//   onTap: () {
//     switchTemplate('BulletForm');
//   },
//   child: Container(
//     // color: Colors.orange,
//     width: MediaQuery.of(context).size.width * .25,
//     child: Icon(CustomIcons.book,
//         size: 20, color: JuntoPalette.juntoGrey),
//   ),
// ),
