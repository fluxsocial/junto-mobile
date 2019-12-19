import 'dart:io';
import 'dart:typed_data' show ByteData, Uint8List;
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
      MaterialPageRoute(
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
  final GlobalKey<ImageCropperState> _imageCropperKey =
      GlobalKey<ImageCropperState>();
  bool _processing = false;

  Future<void> _processCrop(File sourceFile) async {
    final Uint8List sourceBytes = await sourceFile.readAsBytes();
    final ui.Image image = await decodeImageFromList(sourceBytes);

    final ImageCropperState state = _imageCropperKey.currentState;
    final double aspectRatio = state._realSelectedAspectRatio;
    final Offset position = state._position;
    final double scale = state._scale;

    final Size outputSize = state.context.size;
    final FittedSizes fittedSizes = applyBoxFit(
      BoxFit.contain,
      Size(image.width.toDouble(), image.height.toDouble()),
      outputSize,
    );
    final Rect clipRect = Alignment.center.inscribe(
      Size(outputSize.width, outputSize.width / aspectRatio),
      Rect.fromLTWH(0.0, 0.0, outputSize.width, outputSize.height),
    );

    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0.0, 0.0, clipRect.width, clipRect.height));
    canvas.translate(-clipRect.left, -clipRect.top);
    canvas.drawColor(Colors.black, BlendMode.src);
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(
          0.0, 0.0, fittedSizes.source.width, fittedSizes.source.height),
      Rect.fromLTWH(
        (outputSize.width - (fittedSizes.destination.width * scale)) / 2.0 +
            position.dx,
        (outputSize.height - (fittedSizes.destination.height * scale)) / 2.0 +
            position.dy,
        fittedSizes.destination.width * scale,
        fittedSizes.destination.height * scale,
      ),
      Paint()..filterQuality = FilterQuality.high,
    );
    canvas.restore();

    final ui.Picture picture = recorder.endRecording();
    final ui.Image outputImage =
        await picture.toImage(clipRect.width.toInt(), clipRect.height.toInt());
    final ByteData bytes =
        await outputImage.toByteData(format: ui.ImageByteFormat.png);

    final String outputName =
        '${p.basenameWithoutExtension(sourceFile.path)}.png';
    final String outputPath =
        p.join((await pp.getTemporaryDirectory()).path, outputName);
    final File outputFile = File(outputPath);
    await outputFile.writeAsBytes(bytes.buffer.asUint8List());

    PaintingBinding.instance.imageCache.evict(FileImage(outputFile));

    if (mounted) {
      Navigator.of(context).pop(outputFile);
    }
  }

  void _onTickPressed() {
    setState(() => _processing = true);
    _processCrop(widget.sourceFile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(45),
        child: AppBar(
          centerTitle: true,
          title: Text(
            'Crop',
            style: TextStyle(
                color: Theme.of(context).primaryColorDark, fontSize: 15),
          ),
          actions: <Widget>[
            IconButton(
              onPressed: _processing ? null : _onTickPressed,
              icon: Icon(Icons.check),
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          IgnorePointer(
            ignoring: _processing,
            child: ImageCropper(
              key: _imageCropperKey,
              sourceFile: widget.sourceFile,
              aspectRatios: widget.aspectRatios,
            ),
          ),
          AnimatedContainer(
            duration: kThemeAnimationDuration,
            color: _processing
                ? Colors.black.withOpacity(0.8)
                : Colors.transparent,
            child: _processing
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xB3FFFFFF)),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

class ImageCropper extends StatefulWidget {
  const ImageCropper({
    Key key,
    @required this.sourceFile,
    @required this.aspectRatios,
  }) : super(key: key);

  final File sourceFile;
  final List<String> aspectRatios;

  @override
  ImageCropperState createState() => ImageCropperState();
}

class ImageCropperState extends State<ImageCropper> {
  final ValueNotifier<Matrix4> _matrix = ValueNotifier<Matrix4>(null);
  double _scale;
  double _startScale;
  Offset _position;
  Offset _startPosition;
  String _selectedAspectRatio;
  double _realSelectedAspectRatio;

  @override
  void initState() {
    super.initState();
    _position = Offset.zero;
    _scale = 1.0;
    _updateMatrix();
    _setAspectRatio(widget.aspectRatios[0]);
  }

  void _onScaleStart(ScaleStartDetails details) {
    _startScale = _scale;
    _startPosition = details.focalPoint - _position;
    _updateMatrix();
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    _scale = _startScale * details.scale;
    _position = (details.focalPoint - _startPosition) * details.scale;
    _updateMatrix();
  }

  void _updateMatrix() {
    _matrix.value = Matrix4.identity()
      ..translate(_position.dx, _position.dy)
      ..scale(_scale);
  }

  void _onAspectRatio(String aspectRatio) {
    setState(() => _setAspectRatio(aspectRatio));
  }

  void _setAspectRatio(String aspectRatio) {
    _selectedAspectRatio = aspectRatio;
    _realSelectedAspectRatio = _convertAspectRatio(_selectedAspectRatio);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
            child: GestureDetector(
              onScaleStart: _onScaleStart,
              onScaleUpdate: _onScaleUpdate,
              behavior: HitTestBehavior.opaque,
              dragStartBehavior: DragStartBehavior.down,
              child: ClipRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    ValueListenableBuilder<Matrix4>(
                      valueListenable: _matrix,
                      builder:
                          (BuildContext context, Matrix4 value, Widget child) {
                        return Transform(
                          transform: value,
                          alignment: Alignment.center,
                          child: child,
                        );
                      },
                      child: Image.file(widget.sourceFile),
                    ),
                    CustomPaint(
                      painter: _AspectRatioPainter(
                        aspectRatio: _realSelectedAspectRatio,
                        strokeColor: const Color(0xffeeeeee).withOpacity(.50),
                        strokeWidth: 1.0,
                        overlayColor: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (widget.aspectRatios.length > 1)
          SafeArea(
            child: AspectRatio(
              aspectRatio: 6.5,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: <Widget>[
                    for (String aspectRatio in widget.aspectRatios)
                      _AspectRatioButton(
                        onPressed: () => _onAspectRatio(aspectRatio),
                        selected: _selectedAspectRatio == aspectRatio,
                        aspectRatio: aspectRatio,
                      ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _AspectRatioPainter extends CustomPainter {
  const _AspectRatioPainter({
    @required this.aspectRatio,
    @required this.strokeColor,
    @required this.strokeWidth,
    @required this.overlayColor,
  })  : assert(aspectRatio > 0),
        assert(strokeColor != null),
        assert(strokeWidth != null),
        assert(overlayColor != null),
        super();

  final double aspectRatio;
  final Color strokeColor;
  final double strokeWidth;
  final Color overlayColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect bounds = Rect.fromLTWH(0.0, 0.0, size.width, size.height);

    canvas.saveLayer(
        bounds, Paint()..color = Color.fromRGBO(0, 0, 0, strokeColor.opacity));

    final Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square
      ..color = strokeColor.withOpacity(1.0);

    final Rect box = Alignment.center.inscribe(
      Size(size.width, size.width / aspectRatio),
      Rect.fromLTWH(0.0, 0.0, size.width, size.height),
    );

    final Rect strokeRect = box.inflate(-strokeWidth / 2);

    final double hSpace = strokeRect.height * (1.0 / 3.0);
    for (double y = strokeRect.top; y <= strokeRect.bottom; y += hSpace) {
      canvas.drawLine(
          Offset(strokeRect.left, y), Offset(strokeRect.right, y), strokePaint);
    }

    final double wSpace = strokeRect.width * (1.0 / 3.0);
    for (double x = strokeRect.left; x <= strokeRect.right; x += wSpace) {
      canvas.drawLine(
          Offset(x, strokeRect.top), Offset(x, strokeRect.bottom), strokePaint);
    }

    canvas.restore();

    canvas.saveLayer(bounds, Paint());
    canvas.drawColor(overlayColor.withOpacity(0.7), BlendMode.srcOver);
    canvas.drawRect(box, Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AspectRatioPainter oldDelegate) {
    return aspectRatio != oldDelegate.aspectRatio;
  }
}

class _AspectRatioButton extends StatelessWidget {
  const _AspectRatioButton({
    Key key,
    this.onPressed,
    this.selected = false,
    @required this.aspectRatio,
  })  : assert(selected != null),
        super(key: key);

  final VoidCallback onPressed;
  final bool selected;
  final String aspectRatio;

  @override
  Widget build(BuildContext context) {
    final double realAspectRatio = _convertAspectRatio(aspectRatio);
    final Color foreground = Theme.of(context).primaryColor;
    return AspectRatio(
      aspectRatio: 1.0,
      child: Material(
        child: InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: realAspectRatio,
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
                  aspectRatio,
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

double _convertAspectRatio(String aspectRatio) {
  final List<String> aspectParts = aspectRatio.split(':');
  return double.parse(aspectParts[0]) / double.parse(aspectParts[1]);
}
