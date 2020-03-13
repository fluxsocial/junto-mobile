import 'package:flutter/material.dart';

/// Shows Non intrusive feedback widget.
/// The properties [context], [message] must be supplied and not null.
/// The values [color] and [fontColor] both default to [Colors.white] and
/// [Colors.black]. This widget has a default duration of `300` milliseconds for
/// animating and an interval of `750` + [duration] until it is removed.
Future<void> showFeedback(
  final BuildContext context, {
  Widget icon,
  @required final String message,
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
            left: 24.0,
            right: 24.0,
            child: _FeedbackBody(
              icon: icon,
              message: message,
              controller: animation,
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
  const _FeedbackBody({
    Key key,
    @required Animation<double> controller,
    @required this.message,
    this.icon,
  })  : _controller = controller,
        super(key: key);

  final Animation<double> _controller;
  final String message;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget child) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 15,
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Theme.of(context).dividerColor,
                  blurRadius: 6,
                ),
              ]),
          child: SizeTransition(
            sizeFactor: _controller,
            child: FadeTransition(
              opacity:
                  Tween<double>(begin: 0.5, end: 1.00).animate(_controller),
              child: child,
            ),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (icon != null)
            Container(
              margin: const EdgeInsets.only(
                right: 20,
              ),
              child: icon,
            ),
          Text(
            message,
            overflow: TextOverflow.fade,
            style: TextStyle(
              fontSize: 17.0,
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}
