import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/tutorial/indicator.dart';

class JuntoInfoIcon extends StatefulWidget {
  JuntoInfoIcon({
    this.neutralBackground = true,
    this.onPressed,
  });

  final bool neutralBackground;
  final Function onPressed;

  @override
  State<StatefulWidget> createState() {
    return JuntoInfoIconState();
  }
}

class JuntoInfoIconState extends State<JuntoInfoIcon> {
  OverlayEntry _overlayEntry;
  bool overlayOn;

  showOverlay(BuildContext context) async {
    OverlayState overlayState = Overlay.of(context);
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    OverlayEntry overlayEntry = OverlayEntry(
      maintainState: false,
      builder: (context) => Positioned(
        top: offset.dy + size.height + 10.0,
        right: 10,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: 150,
          child: Text(
            'This is the collective of Junto, where all public expressions are shown. ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).backgroundColor,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ),
    );

    overlayState.insert(overlayEntry);

    await Future.delayed(
      Duration(milliseconds: 1000),
    );

    overlayEntry.remove();
  }

  @override
  void initState() {
    super.initState();
    overlayOn = false;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            showOverlay(context);
          },
          child: Container(
            padding: const EdgeInsets.only(left: 10),
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                color: !widget.neutralBackground
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(100),
              ),
              alignment: Alignment.center,
              child: Text(
                '?',
                style: TextStyle(
                  fontSize: 14,
                  color: !widget.neutralBackground
                      ? Color(0xff555555)
                      : Theme.of(context).backgroundColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
