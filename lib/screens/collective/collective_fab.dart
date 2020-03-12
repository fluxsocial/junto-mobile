import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/models.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';

/// Floating action button used by [JuntoCollective]. Controls the switching
/// between [ExpressionFeed] and Perspective screens.
class CollectiveActionButton extends StatelessWidget {
  const CollectiveActionButton({
    Key key,
    @required this.isVisible,
    @required this.actionsVisible,
    @required this.userProfile,
    @required this.onTap,
  }) : super(key: key);
  final ValueNotifier<bool> isVisible;
  final ValueNotifier<bool> actionsVisible;
  final UserData userProfile;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isVisible,
      builder: (BuildContext context, bool visible, Widget child) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: visible ? 1.0 : 0.0,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: ValueListenableBuilder<bool>(
          valueListenable: actionsVisible,
          builder: (BuildContext context, bool value, _) {
            return BottomNav(
              actionsVisible: value,
              onLeftButtonTap: onTap,
            );
          },
        ),
      ),
    );
  }
}
