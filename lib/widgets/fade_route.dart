import 'package:flutter/material.dart';

/// Custom route configured using Junto's fade animation.
/// [child] must not be null.
class FadeRoute<T> extends PageRoute<T> {
  FadeRoute({@required this.child, this.name});

  final Widget child;
  final String name;

  @override
  Color get barrierColor => null;

  @override
  String get barrierLabel => null;

  @override
  RouteSettings get settings => super.settings.copyWith(name: name);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Builder(
      builder: (BuildContext context) {
        return child;
      },
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);
}
