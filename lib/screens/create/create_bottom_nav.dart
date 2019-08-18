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
      color: Colors.blue,
      height: bottomNavVisible ? 90 : 45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          bottomNavVisible
              ? Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: Color(0xffeeeeee),
                        width: .75,
                      ),
                    ),
                  ),
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
                          margin: const EdgeInsets.symmetric(horizontal: 25.0),
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
                          margin: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: const Icon(
                            CustomIcons.feather,
                            size: 20,
                            color: JuntoPalette.juntoGrey,
                          ),
                        ),
                      ),
                      //  GestureDetector(
                      //     onTap: () {
                      //       switchTemplate('bullet');
                      //     },
                      //     child: Container(
                      //         margin: const  EdgeInsets.symmetric
                      //         (horizontal: 25.0),
                      //         child: Icon(CustomIcons.book, size: 20,
                      //             color: JuntoPalette.juntoGrey))),
                      GestureDetector(
                        onTap: () {
                          switchTemplate('photo');
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: const Icon(
                            CustomIcons.camera,
                            size: 20,
                            color: JuntoPalette.juntoGrey,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          switchTemplate('events');
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: const Icon(
                            CustomIcons.event,
                            size: 20,
                            color: JuntoPalette.juntoGrey,
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //     onTap: () {
                      //       switchTemplate('Music');
                      //     },
                      //     child: Container(
                      //         margin: EdgeInsets.symmetric(horizontal: 25.0),
                      //         child: Icon(CustomIcons.moon, size: 20,
                      //             color: JuntoPalette.juntoGrey))),
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
