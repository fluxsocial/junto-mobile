import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/app/screens.dart';

/// Floating action button used by [JuntoCollective]. Controls the switching
/// between [ExpressionFeed] and Perspective screens.
class CollectiveActionButton extends StatelessWidget {
  const CollectiveActionButton({
    Key key,
    @required this.isVisible,
    @required this.actionsVisible,
    @required this.onTap,
    @required this.onUpTap,
    @required this.iconNorth,
  }) : super(key: key);
  final ValueNotifier<bool> isVisible;
  final bool actionsVisible;
  final VoidCallback onTap;
  final VoidCallback onUpTap;
  final bool iconNorth;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isVisible,
      builder: (BuildContext context, bool visible, Widget child) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: visible ? child : const SizedBox(),
        );
      },
      child: Padding(
        key: ValueKey('Down-Button'),
        padding: const EdgeInsets.only(bottom: 25),
        child: BottomNav(
          actionsVisible: actionsVisible,
          onLeftButtonTap: onTap,
          iconNorth: iconNorth,
          featureId: 'collective_toggle_id',
          featureTitle:
              'Toggle between your list of perspectives and the current one you’re looking at.',
          isLastFeature: true,
          source: Screen.collective,
        ),
      ),
    );
  }
}
