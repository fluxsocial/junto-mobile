import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/progress_indicator.dart';

/// A generic [Overlay] which displays a [CircularProgressIndicator] to the user
/// to indicate some background action is ongoing.
class JuntoLoader extends StatelessWidget {
  const JuntoLoader({
    Key key,
    this.width = 250.0,
    this.height = 250.0,
    this.color = Colors.white70,
  }) : super(key: key);
  final double width;
  final double height;
  final Color color;
  static OverlayEntry currentLoader;

  /// Static method which shows the overlay
  static void showLoader(BuildContext context,
      {double width, double height, Color color}) {
    currentLoader = OverlayEntry(builder: (BuildContext context) {
      return Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).backgroundColor.withOpacity(.8),
            child: Center(
              child: SizedBox(
                height: height,
                width: width,
                child: JuntoProgressIndicator(),
              ),
            ),
          ),
        ],
      );
    });
    Overlay.of(context)?.insert(currentLoader);
  }

  /// Static method which hides the overlay
  static void hide() {
    // ignore: always_put_control_body_on_new_line
    if (currentLoader == null) return;
    currentLoader?.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: JuntoProgressIndicator(),
      ),
    );
  }
}
