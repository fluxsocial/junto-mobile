import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pp;

class ImageCroppingDialog extends StatefulWidget {
  const ImageCroppingDialog({
    Key key,
    @required this.sourceFile,
    @required this.aspectRatios,
  }) : super(key: key);

  static Future<File> show(
    BuildContext context,
    File sourceFile, {
    List<String> aspectRatios = const <String>['1:1'],
    RouteSettings settings,
  }) async {
    assert(aspectRatios != null && aspectRatios.isNotEmpty);
    return Navigator.of(context, rootNavigator: true).push<File>(
      MaterialPageRoute<File>(
        settings: settings,
        fullscreenDialog: true,
        builder: (BuildContext context) {
          return ImageCroppingDialog(
            sourceFile: sourceFile,
            aspectRatios: aspectRatios,
          );
        },
      ),
    );
  }

  final File sourceFile;
  final List<String> aspectRatios;

  @override
  _ImageCroppingDialogState createState() => _ImageCroppingDialogState();
}

class _ImageCroppingDialogState extends State<ImageCroppingDialog> {
  final _imageCropperKey = GlobalKey<_ImageCropperState>();
  List<_ImageCropperRatio> _cropperRatios;
  _ImageCropperRatio _selectedRatio;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _cropperRatios = widget.aspectRatios.map((name) => _ImageCropperRatio(name)).toList();
    _selectedRatio = _cropperRatios[0];
  }

  Future<void> _onTickPressed() async {
    if (_processing) {
      return;
    }
    setState(() => _processing = true);
    File result = await _imageCropperKey.currentState.performCrop();
    if (result == null) {
      if (mounted) {
        setState(() => _processing = false);
      }
      return;
    }
    if (mounted) {
      PaintingBinding.instance.imageCache.evict(FileImage(result));
      Navigator.of(context).pop(result);
    }
  }

  void _onAspectRatioSelected(_ImageCropperRatio ratio) {
    setState(() => _selectedRatio = ratio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45.0),
        child: AppBar(
          brightness: Theme.of(context).brightness,
          actions: <Widget>[
            IconButton(
              onPressed: _processing ? null : _onTickPressed,
              icon: Icon(Icons.check),
            ),
          ],
        ),
      ),
      body: IgnorePointer(
        ignoring: _processing,
        child: _ImageCropper(
          key: _imageCropperKey,
          sourceFile: widget.sourceFile,
          aspectRatio: _selectedRatio.value,
        ),
      ),
      bottomNavigationBar: (widget.aspectRatios.length > 1)
          ? BottomAppBar(
              child: AspectRatio(
                aspectRatio: 6.5,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: <Widget>[
                      for (final ratio in _cropperRatios)
                        _AspectRatioButton(
                          ratio: ratio,
                          onPressed: _onAspectRatioSelected,
                          selected: _selectedRatio == ratio,
                        ),
                    ],
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class _ImageCropperRatio {
  factory _ImageCropperRatio(String name) {
    final List<String> aspectParts = name.split(':');
    final value = double.parse(aspectParts[0]) / double.parse(aspectParts[1]);
    return _ImageCropperRatio._(name, value);
  }

  const _ImageCropperRatio._(this.name, this.value);

  final String name;
  final double value;
}

class _AspectRatioButton extends StatelessWidget {
  const _AspectRatioButton({
    Key key,
    @required this.ratio,
    this.onPressed,
    this.selected = false,
  })  : assert(selected != null),
        super(key: key);

  final _ImageCropperRatio ratio;
  final ValueChanged<_ImageCropperRatio> onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color foreground = selected ? theme.primaryColorDark : theme.primaryColorLight;
    return AspectRatio(
      aspectRatio: 1.0,
      child: Material(
        color: theme.backgroundColor,
        child: InkWell(
          onTap: () => onPressed(ratio),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: ratio.value,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: foreground,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  ratio.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.0,
                    color: foreground,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ImageCropper extends StatefulWidget {
  const _ImageCropper({
    Key key,
    @required this.sourceFile,
    @required this.aspectRatio,
  }) : super(key: key);

  final File sourceFile;
  final double aspectRatio;

  @override
  _ImageCropperState createState() => _ImageCropperState();
}

class _ImageCropperState extends State<_ImageCropper> with TickerProviderStateMixin {
  AnimationController _matrixController;
  Animation<Matrix4> _matrixAnimation;

  AnimationController _aspectController;
  Animation<double> _aspectAnimation;

  ui.Image _image;
  ValueNotifier<Matrix4> _viewMatrix;

  Matrix4 _startTouchMatrix;
  Offset _startTouchPoint;

  bool get isNotLoaded => _image == null;

  @override
  void initState() {
    super.initState();
    _matrixController = AnimationController(duration: kThemeAnimationDuration, vsync: this)
      ..addListener(_onAnimateMatrix);
    _matrixAnimation = AlwaysStoppedAnimation<Matrix4>(Matrix4.identity());

    _aspectController = AnimationController(duration: kThemeAnimationDuration, vsync: this)
      ..addListener(_onAnimateAspect);
    _aspectAnimation = AlwaysStoppedAnimation<double>(widget.aspectRatio);

    _viewMatrix = ValueNotifier<Matrix4>(Matrix4.identity());
    _loadImage();
  }

  Future<void> _loadImage() async {
    final sourceBytes = await widget.sourceFile.readAsBytes();
    final image = await decodeImageFromList(sourceBytes);
    if (mounted) {
      setState(() => _image = image);
      startWithCenterCroppedImage();
      checkMatrixBounds();
    }
  }

  @override
  void reassemble() {
    super.reassemble();
    startWithCenterCroppedImage();
    checkMatrixBounds();
  }

  @override
  void didUpdateWidget(_ImageCropper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.aspectRatio != oldWidget.aspectRatio) {
      updateAspectRatio();
    }
  }

  void _onAnimateMatrix() {
    _viewMatrix.value = _matrixAnimation.value;
  }

  void _onAnimateAspect() {
    scheduleMicrotask(() => checkMatrixBounds(withScale: true));
  }

  Future<File> performCrop() async {
    if (isNotLoaded) {
      return null;
    }

    // ENTER HERE AT YOUR OWN PERIL

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final imageSize = Size(_image.width.toDouble(), _image.height.toDouble());
    final viewSize = context.size;
    final imageRect = _calculateAspectRect(imageSize, widget.aspectRatio);
    final viewRect = _calculateAspectRect(viewSize, widget.aspectRatio);

    final scale = math.max(
      imageRect.width / viewRect.width,
      imageRect.height / viewRect.height,
    );

    final tx = (imageRect.left - viewRect.left * scale);
    final ty = (imageRect.top - viewRect.top * scale);
    final translation = Matrix4.translationValues(tx, ty, 0.0);
    final imageTransform = translation * scale * _viewMatrix.value;

    canvas.translate(-imageRect.left, -imageRect.top);
    canvas.drawImage(
      _image,
      Offset.zero,
      Paint()
        ..imageFilter = ui.ImageFilter.matrix(
          imageTransform.storage,
          filterQuality: FilterQuality.high,
        ),
    );

    final picture = recorder.endRecording();
    final outputImage = await picture.toImage(imageRect.width.toInt(), imageRect.height.toInt());
    final bytes = await outputImage.toByteData(format: ui.ImageByteFormat.png);

    final timeStamp = DateTime.now().millisecondsSinceEpoch;
    final outputBase = p.basenameWithoutExtension(widget.sourceFile.path);
    final outputPath = p.join((await pp.getTemporaryDirectory()).path, '$outputBase-$timeStamp.png');
    final outputFile = File(outputPath);
    await outputFile.writeAsBytes(bytes.buffer.asUint8List());

    return outputFile;
  }

  @override
  void dispose() {
    _aspectController.removeListener(_onAnimateAspect);
    _aspectController.dispose();
    _matrixController.removeListener(_onAnimateMatrix);
    _matrixController.dispose();
    super.dispose();
  }

  void updateAspectRatio() {
    final double begin = _aspectAnimation?.value ?? widget.aspectRatio;
    final double end = widget.aspectRatio;
    _aspectAnimation = Tween<double>(begin: begin, end: end).animate(_aspectController);
    _aspectController.forward(from: 0.0);
  }

  void startWithCenterCroppedImage() {
    if (isNotLoaded) {
      return;
    }

    final imageSize = Size(_image.width.toDouble(), _image.height.toDouble());
    final viewSize = context.size;
    final aspectSize = _calculateAspectSize(context.size, widget.aspectRatio);
    final widthScale = aspectSize.width / imageSize.width;
    final heightScale = aspectSize.height / imageSize.height;

    double scale;
    if (widthScale / heightScale < 1.0) {
      scale = heightScale;
    } else {
      scale = widthScale;
    }

    final tx = (viewSize.width - (imageSize.width * scale)) / 2.0;
    final ty = (viewSize.height - (imageSize.height * scale)) / 2.0;
    _viewMatrix.value = Matrix4.translationValues(tx, ty, 0.0) * scale;
  }

  Rect _getAspectRect() {
    return _calculateAspectRect(context.size, _aspectAnimation.value);
  }

  Rect getDisplayRect() {
    if (isNotLoaded) {
      return Rect.zero;
    }
    return MatrixUtils.transformRect(
      _viewMatrix.value,
      Rect.fromLTWH(0.0, 0.0, _image.width.toDouble(), _image.height.toDouble()),
    );
  }

  void checkMatrixBounds({bool withScale = false}) {
    final aspectRect = _getAspectRect();

    Rect displayRect = getDisplayRect();
    if (withScale && (displayRect.width < aspectRect.width || displayRect.height < aspectRect.height)) {
      _matrixController.stop();
      _viewMatrix.value = _scaleMatrix(
        matrix: _viewMatrix.value,
        scale: math.max(
          aspectRect.width / displayRect.width,
          aspectRect.height / displayRect.height,
        ),
        offset: displayRect.center,
      );
      displayRect = getDisplayRect();
    }

    double deltaX = 0.0, deltaY = 0.0;
    if (displayRect.height <= aspectRect.height) {
      deltaY = (aspectRect.height - displayRect.height) / 2 - displayRect.top + aspectRect.top;
    } else if (displayRect.top > aspectRect.top) {
      deltaY = aspectRect.top - displayRect.top;
    } else if (displayRect.bottom < aspectRect.bottom) {
      deltaY = aspectRect.bottom - displayRect.bottom;
    }

    if (displayRect.width <= aspectRect.width) {
      deltaX = (aspectRect.width - displayRect.width) / 2 - displayRect.left + aspectRect.left;
    } else if (displayRect.left > aspectRect.left) {
      deltaX = aspectRect.left - displayRect.left;
    } else if (displayRect.right < aspectRect.right) {
      deltaX = aspectRect.right - displayRect.right;
    }

    _viewMatrix.value = Matrix4.translationValues(deltaX, deltaY, 0.0) * _viewMatrix.value;
  }

  void _onScaleStart(ScaleStartDetails details) {
    _startTouchMatrix = _viewMatrix.value;
    _startTouchPoint = details.localFocalPoint;
    _matrixController.stop();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    _viewMatrix.value = _scaleMatrix(
      matrix: _startTouchMatrix,
      scale: details.scale,
      offset: details.localFocalPoint,
      delta: _startTouchPoint - details.localFocalPoint,
    );
    checkMatrixBounds();
  }

  void _onScaleEnd(ScaleEndDetails details) {
    checkMatrixBounds();
    final displayRect = getDisplayRect();
    final aspectRect = _getAspectRect();
    if (displayRect.width < aspectRect.width || displayRect.height < aspectRect.height) {
      final end = _scaleMatrix(
        matrix: _viewMatrix.value,
        scale: math.max(
          aspectRect.width / displayRect.width,
          aspectRect.height / displayRect.height,
        ),
        offset: displayRect.center,
      );
      _matrixAnimation = Matrix4Tween(
        begin: _viewMatrix.value,
        end: end,
      ).animate(_matrixController);
      _matrixController.forward(from: 0.0);
    }
  }

  Matrix4 _scaleMatrix({
    @required Matrix4 matrix,
    @required double scale,
    Offset offset = Offset.zero,
    Offset delta = Offset.zero,
  }) {
    return Matrix4.translationValues(offset.dx, offset.dy, 0.0) *
        Matrix4.diagonal3Values(scale, scale, 1.0) *
        Matrix4.translationValues(-(offset.dx + delta.dx), -(offset.dy + delta.dy), 0.0) *
        matrix;
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onScaleStart: _onScaleStart,
            onScaleUpdate: _onScaleUpdate,
            onScaleEnd: _onScaleEnd,
            behavior: HitTestBehavior.opaque,
            dragStartBehavior: DragStartBehavior.down,
            child: CustomPaint(
              painter: _AspectRatioPainter(
                aspectAnimation: _aspectAnimation,
                strokeColor: const Color(0xffeeeeee),
                strokeWidth: 1.0,
                overlayColor: Colors.black.withOpacity(0.8),
                image: _image,
                imageMatrix: _viewMatrix,
              ),
              size: Size.infinite,
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: AnimatedOpacity(
              duration: kThemeAnimationDuration,
              opacity: isNotLoaded ? 1.0 : 0.0,
              child: Container(
                color: Colors.black.withOpacity(0.8),
                alignment: Alignment.center,
                child: TickerMode(
                  enabled: isNotLoaded,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xB3FFFFFF)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AspectRatioPainter extends CustomPainter {
  _AspectRatioPainter({
    @required this.aspectAnimation,
    @required this.strokeColor,
    @required this.strokeWidth,
    @required this.overlayColor,
    @required this.image,
    @required this.imageMatrix,
  })  : assert(aspectAnimation != null),
        assert(strokeColor != null),
        assert(strokeWidth != null),
        assert(overlayColor != null),
        super(repaint: Listenable.merge(<Listenable>[aspectAnimation, imageMatrix]));

  final Animation<double> aspectAnimation;
  final Color strokeColor;
  final double strokeWidth;
  final Color overlayColor;
  final ui.Image image;
  final ValueNotifier<Matrix4> imageMatrix;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect bounds = Rect.fromLTWH(0.0, 0.0, size.width, size.height);

    if (image != null) {
      canvas.save();
      canvas.transform(imageMatrix.value.storage);
      canvas.drawImage(
        image,
        Offset.zero,
        Paint()..filterQuality = FilterQuality.high,
      );
      canvas.restore();
    }

    canvas.saveLayer(bounds, Paint()..color = Color.fromRGBO(0, 0, 0, strokeColor.opacity));

    final Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square
      ..color = strokeColor.withOpacity(1.0);

    final Rect box = _calculateAspectRect(size, aspectAnimation.value);

    final Rect strokeRect = box.inflate(-strokeWidth / 2);

    final double hSpace = strokeRect.height * (1.0 / 3.0);
    for (double y = strokeRect.top; y <= strokeRect.bottom; y += hSpace) {
      canvas.drawLine(Offset(strokeRect.left, y), Offset(strokeRect.right, y), strokePaint);
    }

    final double wSpace = strokeRect.width * (1.0 / 3.0);
    for (double x = strokeRect.left; x <= strokeRect.right; x += wSpace) {
      canvas.drawLine(Offset(x, strokeRect.top), Offset(x, strokeRect.bottom), strokePaint);
    }

    canvas.restore();

    canvas.saveLayer(bounds, Paint());
    canvas.drawColor(overlayColor, BlendMode.srcOver);
    canvas.drawRect(box, Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AspectRatioPainter oldDelegate) {
    return aspectAnimation != oldDelegate.aspectAnimation ||
        strokeColor != oldDelegate.strokeColor ||
        strokeWidth != oldDelegate.strokeWidth ||
        overlayColor != oldDelegate.overlayColor ||
        image != oldDelegate.image ||
        imageMatrix != oldDelegate.imageMatrix;
  }
}

Size _calculateAspectSize(Size size, double aspectRatio) {
  double width = size.width;
  double height = width / aspectRatio;
  if (height > size.height) {
    height = size.height;
    width = height * aspectRatio;
  }
  return Size(width, height);
}

Rect _calculateAspectRect(Size size, double aspectRatio) {
  return Alignment.center.inscribe(
    _calculateAspectSize(size, aspectRatio),
    Rect.fromLTWH(0.0, 0.0, size.width, size.height),
  );
}
