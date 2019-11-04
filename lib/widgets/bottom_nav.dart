import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/app/palette.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';

// This widget is the bottom navigation on all of the main screens. Members can
// navigate to the home, spheres, create, packs, and den screens.
class BottomNav extends StatefulWidget {
  const BottomNav({
    Key key,
    @required this.currentIndex,
    @required this.setIndex,
  }) : super(key: key);

  final int currentIndex;
  final ValueChanged<int> setIndex;

  @override
  State<StatefulWidget> createState() {
    return BottomNavState();
  }
}

class BottomNavState extends State<BottomNav> {
  _navCreate() {
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
        transitionDuration: const Duration(
          milliseconds: 200,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: SizedBox(
        height: 48.0,
        child: Material(
          color: Theme.of(context).backgroundColor,
          shape: Border(
            top: BorderSide(
              color: Theme.of(context).dividerColor,
              width: .5,
            ),
          ),
          child: Row(
            children: <Widget>[
              _BottomNavButton(
                index: 0,
                selectedIndex: widget.currentIndex,
                icon: CustomIcons.enso,
                onTap: widget.setIndex,
              ),
              _BottomNavButton(
                index: 1,
                selectedIndex: widget.currentIndex,
                icon: CustomIcons.spheres,
                onTap: widget.setIndex,
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
                      transitionDuration: const Duration(
                        milliseconds: 200,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * .2,
                  height: 48,
                  color: Colors.transparent,
                  child: AnimatedSwitcher(
                    duration: kThemeChangeDuration,
                    child: Icon(CustomIcons.lotus,
                        size: 20, color: Theme.of(context).primaryColorLight),
                  ),
                ),
              ),
              _BottomNavButton(
                index: 2,
                selectedIndex: widget.currentIndex,
                icon: CustomIcons.packs,
                onTap: widget.setIndex,
              ),
              GestureDetector(
                onTap: () => widget.setIndex(3),
                child: Container(
                  width: MediaQuery.of(context).size.width * .2,
                  height: 48,
                  color: Colors.transparent,
                  alignment: Alignment.center,
                  child: Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/junto-mobile__placeholder--member.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavButton extends StatelessWidget {
  const _BottomNavButton({
    Key key,
    @required this.index,
    @required this.selectedIndex,
    @required this.icon,
    @required this.onTap,
  }) : super(key: key);

  final int index;
  final int selectedIndex;
  final IconData icon;
  final dynamic onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        width: MediaQuery.of(context).size.width * .2,
        height: 48,
        color: Colors.transparent,
        child: AnimatedSwitcher(
          duration: kThemeChangeDuration,
          child: Icon(
            icon,
            key: Key('index-$index-$selectedIndex'),
            size: 20,
            color: selectedIndex == index
                ? Theme.of(context).primaryColorDark
                : Theme.of(context).primaryColorLight
          ),
        ),
      ),
    );
  }
}
