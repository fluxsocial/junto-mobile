import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomRefresh extends StatelessWidget {
  CustomRefresh({
    Key key,
    this.child,
    this.refresh,
  }) : super(key: key);

  final Widget child;
  final Function refresh;

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      offsetToArmed: 100,
      onRefresh: refresh,
      builder: (
        BuildContext context,
        Widget child,
        IndicatorController controller,
      ) {
        return AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, _) {
            return Stack(
              alignment: Alignment.topCenter,
              children: <Widget>[
                if (!controller.isIdle)
                  Positioned(
                    top: 25.0 * controller.value,
                    child: SpinKitFadingCircle(
                      color: Theme.of(context).dividerColor,
                      size: 38.0,
                    ),
                  ),
                Transform.translate(
                  offset: Offset(0, 80.0 * controller.value),
                  child: child,
                ),
              ],
            );
          },
        );
      },
      child: child,
    );
  }
}
