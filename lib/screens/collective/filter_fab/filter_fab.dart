import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/typography/palette.dart';

/// Gradient [FloatingActionButton] used for filtering
/// Collectives.
class CollectiveFilterFAB extends StatelessWidget {
  CollectiveFilterFAB(this.isVisible, this.toggleFilter);

  /// Passed via the constructor, used to show and hide the FAB
  final ValueNotifier<bool> isVisible;

  /// Callback used to react to onTap events
  final Function toggleFilter;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isVisible,
      builder: (context, value, _) => AnimatedOpacity(
        duration: Duration(milliseconds: 200),
        opacity: value ? 1.0 : 0.0,
        child: GestureDetector(
          onTap: () => toggleFilter(context),
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                stops: [0.1, 0.9],
                colors: [
                  JuntoPalette.juntoPurple,
                  JuntoPalette.juntoBlue,
                ],
              ),
              color: Colors.white.withOpacity(.7),
              border: Border.all(
                color: Colors.white,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
            alignment: Alignment.center,
            child: Text(
              '#',
              style: TextStyle(
                color: Color(0xffffffff),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
