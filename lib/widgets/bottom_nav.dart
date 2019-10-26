import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/create/create.dart';
import 'package:junto_beta_mobile/app/palette.dart';

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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      left: false,
      right: false,
      child: SizedBox(
        height: 48.0,
        child: Material(
          color: Colors.white,
          shape: const Border(
            top: BorderSide(
              color: JuntoPalette.juntoFade,
              width: .75,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _BottomNavButton(
                index: 0,
                selectedIndex: widget.currentIndex,
                icon: CustomIcons.home,
                onTap: widget.setIndex,
              ),
              _BottomNavButton(
                index: 1,
                selectedIndex: widget.currentIndex,
                icon: CustomIcons.circle,
                onTap: widget.setIndex,
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder<dynamic>(
                        pageBuilder: (
                          BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                        ) {
                          //FIXME: This address should be replaced with the Junto Collective address once it is created.
                          return const JuntoCreate(
                            'collective',
                            address: 'd7f5186b-0281-4723-b5d4-1ff24eb0beb2',
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
                  child: const Icon(
                    CustomIcons.lotus,
                    color: JuntoPalette.juntoGreyLight,
                  ),
                ),
              ),
              _BottomNavButton(
                index: 2,
                selectedIndex: widget.currentIndex,
                icon: CustomIcons.triangle,
                onTap: widget.setIndex,
              ),
              _BottomNavButton(
                index: 3,
                selectedIndex: widget.currentIndex,
                icon: CustomIcons.profile,
                onTap: widget.setIndex,
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
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: RotatedBox(
          quarterTurns: icon == CustomIcons.triangle ? 2 : 0,
          child: AnimatedSwitcher(
            duration: kThemeChangeDuration,
            child: Icon(
              icon,
              key: Key('index-$index-$selectedIndex'),
              size: 20,
              color: selectedIndex == index
                  ? JuntoPalette.juntoGrey
                  : JuntoPalette.juntoGreyLight,
            ),
          ),
        ),
      ),
    );
  }
}
