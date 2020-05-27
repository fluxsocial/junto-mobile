import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/backend/backend.dart';
import 'package:junto_beta_mobile/widgets/bottom_nav.dart';
import 'package:junto_beta_mobile/app/screens.dart';

class PacksActionButtons extends StatelessWidget {
  const PacksActionButtons({
    Key key,
    @required ValueNotifier<bool> isVisible,
  })  : _isVisible = isVisible,
        super(key: key);

  final ValueNotifier<bool> _isVisible;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isVisible,
      builder: (BuildContext context, bool visible, Widget child) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: visible ? 1.0 : 0.0,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 25),
        child: BottomNav(
          expressionContext: ExpressionContext.Group,
          source: Screen.packs,
        ),
      ),
    );
  }
}
