import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InteractiveImageViewerOverlay extends StatefulWidget {
  final Widget child;
  final double maxScale;

  const InteractiveImageViewerOverlay({
    Key key,
    @required this.child,
    this.maxScale,
  }) : super(key: key);

  @override
  _InteractiveImageViewerOverlayState createState() =>
      _InteractiveImageViewerOverlayState();
}

class _InteractiveImageViewerOverlayState
    extends State<InteractiveImageViewerOverlay>
    with SingleTickerProviderStateMixin {
  var viewerKey = GlobalKey();
  Rect placeholder;
  OverlayEntry entry;
  var controller = TransformationController();
  Matrix4Tween snapTween;
  AnimationController snap;

  @override
  void initState() {
    super.initState();
    snap = AnimationController(vsync: this);
    snap.addListener(() {
      if (snapTween == null) return;
      controller.value = snapTween.evaluate(snap);
      if (snap.isCompleted) {
        entry.remove();
        entry = null;
        setState(() {
          placeholder = null;
        });
      }
    });
  }

  @override
  void dispose() {
    snap.dispose();
    super.dispose();
  }

  Widget buildViewer(BuildContext context) {
    return InteractiveViewer(
        key: viewerKey,
        transformationController: controller,
        panEnabled: false,
        maxScale: widget.maxScale ?? 2.5,
        child: widget.child,
        onInteractionStart: (details) {
          if (placeholder != null) return;

          setState(() {
            var renderObject =
                viewerKey.currentContext.findRenderObject() as RenderBox;
            placeholder = Rect.fromPoints(
              renderObject.localToGlobal(Offset.zero),
              renderObject
                  .localToGlobal(renderObject.size.bottomRight(Offset.zero)),
            );
          });

          entry = OverlayEntry(
            builder: (context) {
              return Stack(
                children: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 250),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(child: child, scale: animation);
                    },
                    child: placeholder != null
                        ? Container(
                            color: Theme.of(context)
                                .backgroundColor
                                .withOpacity(.8),
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                          )
                        : Container(),
                  ),
                  Positioned.fromRect(
                    rect: placeholder,
                    child: buildViewer(context),
                  ),
                ],
              );
            },
          );

          Overlay.of(context).insert(entry);
        },
        onInteractionEnd: (details) {
          snapTween = Matrix4Tween(
            begin: controller.value,
            end: Matrix4.identity(),
          );
          snap.value = 0;
          snap.animateTo(
            1,
            duration: Duration(milliseconds: 250),
            curve: Curves.ease,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    var viewer = placeholder != null
        ? SizedBox.fromSize(size: placeholder.size)
        : buildViewer(context);

    return Container(
      child: viewer,
      decoration: BoxDecoration(),
    );
  }
}
