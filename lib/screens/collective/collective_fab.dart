import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/app/screens.dart';

/// Floating action button used by [JuntoCollective]. Controls the switching
/// between [ExpressionFeed] and Perspective screens.
class CollectiveActionButton extends StatelessWidget {
  const CollectiveActionButton({
    Key key,
    @required this.isVisible,
  }) : super(key: key);
  final ValueNotifier<bool> isVisible;

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
          source: Screen.collective,
        ),
      ),
    );
  }
}
