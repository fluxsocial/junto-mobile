import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/models/expression.dart';
import 'package:junto_beta_mobile/utils/cache_manager.dart';
import 'package:junto_beta_mobile/widgets/custom_parsed_text.dart';
import 'package:junto_beta_mobile/widgets/image_wrapper.dart';

class PhotoOpen extends StatelessWidget {
  const PhotoOpen(this.photoExpression);

  final ExpressionResponse photoExpression;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InteractiveViewerOverlay(
            maxScale: 2,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: ImageWrapper(
                imageUrl: photoExpression.expressionData.image,
                placeholder: (BuildContext context, String _) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    color: Theme.of(context).dividerColor,
                    child: CachedNetworkImage(
                        imageUrl: photoExpression.thumbnailSmall,
                        fit: BoxFit.cover,
                        cacheManager: CustomCacheManager(),
                        placeholder: (BuildContext context, String _) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            color: Theme.of(context).dividerColor,
                          );
                        }),
                  );
                },
                fit: BoxFit.cover,
              ),
            ),
          ),
          if (photoExpression.expressionData.caption.trim().isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomParsedText(
                photoExpression.expressionData.caption.trim(),
                defaultTextStyle: Theme.of(context).textTheme.caption,
                mentionTextStyle: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontSize: 17,
                  height: 1.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
        ],
      ),
    );
  }
}

class ZoomableImage extends StatefulWidget {
  final Widget child;

  const ZoomableImage({Key key, this.child}) : super(key: key);

  @override
  _ZoomableImageState createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<ZoomableImage>
    with TickerProviderStateMixin {
  final TransformationController _transformationController =
      TransformationController();
  Animation<Matrix4> _animationReset;
  AnimationController _controller;

  void _reset() {
    _transformationController.value = _animationReset.value;

    if (!_controller.isAnimating) {
      _animationReset?.removeListener(_reset);
      _animationReset = null;
      _controller.reset();
    }
  }

  void _animateResetInitialize() {
    _controller.reset();
    _animationReset = Matrix4Tween(
      begin: _transformationController.value,
      end: Matrix4.identity(),
    ).animate(_controller);
    _animationReset.addListener(_reset);
    _controller.forward();
  }

  void _animatedResetStop() {
    _controller.stop();
    _animationReset?.removeListener(_reset);
    _animationReset = null;
    _controller.reset();
  }

  void _onInteractionStart(ScaleStartDetails details) {
    if (_controller.status == AnimationStatus.forward) {
      _animatedResetStop();
    }
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      boundaryMargin: EdgeInsets.all(double.infinity),
      transformationController: _transformationController,
      minScale: 1,
      maxScale: 1.6,
      onInteractionStart: _onInteractionStart,
      onInteractionEnd: (details) {
        _animateResetInitialize();
      },
      child: widget.child,
    );
  }
}

class InteractiveViewerOverlay extends StatefulWidget {
  final Widget child;
  final double maxScale;

  const InteractiveViewerOverlay({
    Key key,
    @required this.child,
    this.maxScale,
  }) : super(key: key);

  @override
  _InteractiveViewerOverlayState createState() =>
      _InteractiveViewerOverlayState();
}

class _InteractiveViewerOverlayState extends State<InteractiveViewerOverlay>
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
              return Positioned.fromRect(
                rect: placeholder,
                child: buildViewer(context),
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
