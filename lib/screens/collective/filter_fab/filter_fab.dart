import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/palette.dart';

/// Gradient [FloatingActionButton] used for filtering
/// Collectives.
class CollectiveFilterFAB extends StatelessWidget {
  const CollectiveFilterFAB({
    Key key,
    @required this.isVisible,
    @required this.toggleFilter,
  }) : super(key: key);

  /// Passed via the constructor, used to show and hide the FAB
  final ValueNotifier<bool> isVisible;

  /// Callback used to react to onTap events
  final Function toggleFilter;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isVisible,
      builder: (BuildContext context, bool value, _) => AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: value ? 1.0 : 0.0,
            child: GestureDetector(
              onTap: () => toggleFilter(context),
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: <double>[0.1, 0.9],
                    colors: <Color>[
                      JuntoPalette.juntoSecondary,
                      JuntoPalette.juntoPrimary,
                    ],
                  ),
                  color: JuntoPalette.juntoWhite.withOpacity(.7),
                  border: Border.all(
                    color: JuntoPalette.juntoWhite,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                alignment: Alignment.center,
                child: const Text(
                  '#',
                  style: TextStyle(
                    color: JuntoPalette.juntoWhite,
                  ),
                ),
              ),
            ),
          ),
    );
  }
}
