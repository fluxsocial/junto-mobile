import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/custom_icons.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';

// This widget is the bottom navigation on all of the main screens. Members can
// navigate to the home, spheres, create, packs, and den screens.
class BottomNav extends StatefulWidget {
  const BottomNav(this.currentIndex, this.setIndex);

  final int currentIndex;
  final ValueChanged<int> setIndex;

  @override
  State<StatefulWidget> createState() {
    return BottomNavState();
  }
}

class BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xffeeeeee),
            width: .75,
          ),
        ),
      ),
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              widget.setIndex(0);
            },
            child: Icon(
              CustomIcons.home,
              size: 20,
              color: widget.currentIndex == 0
                  ? const Color(0xff333333)
                  : const Color(0xff999999),
            ),
          ),
          GestureDetector(
            onTap: () => widget.setIndex(1),
            child: Icon(
              CustomIcons.circle,
              size: 20,
              color: widget.currentIndex == 1
                  ? const Color(0xff333333)
                  : const Color(0xff999999),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder<dynamic>(
                  pageBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                  ) {
                    return const JuntoCreate(
                      'collective',
                    );
                  },
                  transitionsBuilder: (
                    BuildContext context,
                    Animation<double> animation,
                    Animation<double> secondaryAnimation,
                    Widget child,
                  ) {
                    return FadeTransition(
                      opacity: animation,
                      child: child,
                    );
                  },
                  transitionDuration: Duration(
                    milliseconds: 200,
                  ),
                ),
              );
            },
            child: Icon(
              CustomIcons.lotus,
              color: const Color(0xff999999),
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.setIndex(2);
            },
            child: RotatedBox(
              quarterTurns: 2,
              child: Icon(
                CustomIcons.triangle,
                size: 20,
                color: widget.currentIndex == 2
                    ? const Color(0xff333333)
                    : const Color(0xff999999),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              widget.setIndex(3);
            },
            child: Icon(
              CustomIcons.profile,
              size: 20,
              color: widget.currentIndex == 3
                  ? const Color(0xff333333)
                  : const Color(0xff999999),
            ),
          )
        ],
      ),
    );
  }
}
