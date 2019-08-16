import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/typography/palette.dart';

class CreateBottomNav extends StatelessWidget {
  Function switchTemplate;
  bool bottomNavVisible;
  CreateBottomNav(this.switchTemplate, this.bottomNavVisible);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      height: bottomNavVisible ? 90 : 45,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          bottomNavVisible
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Color(0xffeeeeee), width: .75),
                    ),
                  ),
                  alignment: Alignment.center,
                  height: 45,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          switchTemplate('longform');
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 25.0),
                          child: Icon(
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
                          margin: EdgeInsets.symmetric(horizontal: 25.0),
                          child: Icon(CustomIcons.feather,
                              size: 20, color: JuntoPalette.juntoGrey),
                        ),
                      ),
                      // GestureDetector(
                      //     onTap: () {
                      //       switchTemplate('bullet');
                      //     },
                      //     child: Container(
                      //         margin: EdgeInsets.symmetric(horizontal: 25.0),
                      //         child: Icon(CustomIcons.book, size: 20,
                      //             color: JuntoPalette.juntoGrey))),
                      GestureDetector(
                        onTap: () {
                          switchTemplate('photo');
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 25.0),
                          child: Icon(CustomIcons.camera,
                              size: 20, color: JuntoPalette.juntoGrey),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          switchTemplate('events');
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 25.0),
                          child: Icon(
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
              : SizedBox(),
          Container(
            alignment: Alignment.center,
            height: 45,
            color: Colors.white,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
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
