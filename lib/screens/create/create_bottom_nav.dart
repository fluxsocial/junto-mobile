import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/typography/palette.dart';

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
                          switchTemplate('longform');
                        },
                        child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width * .25,
                          child: const Icon(
                            CustomIcons.longform,
                            size: 20,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          switchTemplate('shortform');
                        },
                        child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width * .25,
                          child: const Icon(
                            CustomIcons.feather,
                            size: 20,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          switchTemplate('photo');
                        },
                        child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width * .25,
                          child: const Icon(
                            CustomIcons.camera,
                            size: 20,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          switchTemplate('events');
                        },
                        child: Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width * .25,
                          child: const Icon(
                            CustomIcons.event,
                            size: 20,
                            color: Color(0xff000000),
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
                color: JuntoPalette.juntoBlue,
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
//     switchTemplate('bullet');
//   },
//   child: Container(
//     // color: Colors.orange,
//     width: MediaQuery.of(context).size.width * .25,
//     child: Icon(CustomIcons.book,
//         size: 20, color: JuntoPalette.juntoGrey),
//   ),
// ),
