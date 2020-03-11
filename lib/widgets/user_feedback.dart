import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';

/// Shows Non intrusive feedback widget.
/// The properties [context], [message] must be supplied and not null.
/// The values [color] and [fontColor] both default to [Colors.white] and
/// [Colors.black]. This widget has a default duration of `300` milliseconds for
/// animating and an interval of `750` + [duration] until it is removed.
Future<void> showFeedback(
  final BuildContext context, {
  @required final String message,
  Color color,
  Color fontColor,
  Duration duration = const Duration(milliseconds: 300),
}) async {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionDuration: duration,
    pageBuilder: (
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
    ) {
      return Stack(
        children: <Widget>[
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 12.0,
            left: 48.0,
            right: 48.0,
            child: _FeedbackBody(
              message: message,
              controller: animation,
              backgroundColor:
                  color ?? Theme.of(context).colorScheme.primaryVariant,
              fontColor: fontColor ?? Colors.white,
            ),
          ),
        ],
      );
    },
  );
  await Future<void>.delayed(const Duration(milliseconds: 730) + duration);
  Navigator.of(context).pop();
}

class _FeedbackBody extends StatelessWidget {
  const _FeedbackBody(
      {Key key,
      @required Animation<double> controller,
      @required this.backgroundColor,
      @required this.message,
      @required this.fontColor})
      : _controller = controller,
        super(key: key);

  final Animation<double> _controller;
  final Color backgroundColor;
  final Color fontColor;
  final String message;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: Tween<double>(begin: 0.5, end: 1.00).animate(_controller),
          child: SizeTransition(
            sizeFactor: _controller,
            child: Material(
              borderRadius: BorderRadius.circular(8.0 * _controller.value),
              color: backgroundColor,
              child: child,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 10.0,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 24,
              child: Icon(
                CustomIcons.create,
                size: 18,
                color: fontColor,
              ),
            ),
            const SizedBox(width: 24.0),
            Expanded(
              child: Text(
                message,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontSize: 16.0,
                  color: fontColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
