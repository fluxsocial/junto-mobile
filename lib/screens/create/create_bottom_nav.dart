import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';

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
                  child: Row(
                    children: <Widget>[
                      _CreateExpressionButton(
                        onButtonPressed: () {
                          switchTemplate('LongForm');
                        },
                        icon: CustomIcons.longform,
                      ),
                      _CreateExpressionButton(
                        onButtonPressed: () {
                          switchTemplate('ShortForm');
                        },
                        icon: CustomIcons.feather,
                      ),
                      _CreateExpressionButton(
                        onButtonPressed: () {
                          switchTemplate('PhotoForm');
                        },
                        icon: CustomIcons.camera,
                      ),
                      _CreateExpressionButton(
                        onButtonPressed: () {
                          switchTemplate('EventForm');
                        },
                        icon: CustomIcons.event,
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

class _CreateExpressionButton extends StatelessWidget {
  const _CreateExpressionButton({
    Key key,
    @required this.onButtonPressed,
    @required this.icon,
  }) : super(key: key);
  final VoidCallback onButtonPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onButtonPressed,
        child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width * .25,
          child: Icon(
            icon,
            size: 20,
            color: JuntoPalette.juntoBlack,
          ),
        ),
      ),
    );
  }
}
