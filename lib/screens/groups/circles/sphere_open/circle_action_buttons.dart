import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/app/screens.dart';

class CircleActionButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> _isVisible = ValueNotifier<bool>(true);

    return ValueListenableBuilder<bool>(
      valueListenable: _isVisible,
      builder: (BuildContext context, bool visible, Widget child) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: visible ? 1.0 : 0.0,
          child: child,
        );
      },
      child: BottomNav(
        expressionContext: ExpressionContext.Group,
        source: Screen.groups,
      ),
    );
  }
}
