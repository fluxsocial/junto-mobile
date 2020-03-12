// JuntoFilterDrawer is based on flutter_inner_drawer licensed under MIT
// https://github.com/Dn-a/flutter_inner_drawer

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Signature for the callback that's called when a [JuntoFilterDrawer] is
/// opened or closed.
typedef JuntoDrawerCallback = void Function(bool isOpened);

/// Signature for when a pointer that is in contact with the screen and moves to the right or left
/// values between 1 and 0
typedef JuntoDragUpdateCallback = void Function(
    double value, DrawerPosition position);

/// Animation type of a [JuntoFilterDrawer].
enum InnerDrawerAnimation {
  static,
  linear,
  quadratic,
}

enum DrawerPosition {
  start,
  end,
}

//width before initState
const double _kWidth = 400;
const double _kMinFlingVelocity = 265.0;
const double _kEdgeDragWidth = 20.0;
const Duration _kBaseSettleDuration = Duration(milliseconds: 246);

class JuntoFilterDrawer extends StatefulWidget {
  const JuntoFilterDrawer({
    GlobalKey key,
    @required this.leftDrawer,
    @required this.scaffold,
    @required this.rightMenu,
    this.offset = const IDOffset.horizontal(0.8),
    this.borderRadius = 0,
    this.onTapClose = false,
    this.swipe = true,
    this.duration,
    this.animationType = InnerDrawerAnimation.static,
    this.innerDrawerCallback,
    this.onDragUpdate,
  })  : assert(scaffold != null),
        super(key: key);

  /// Left child
  final Widget leftDrawer;

  /// A Scaffold is generally used but you are free to use other widgets
  final Widget scaffold;

  /// Menu shown on the right of the app
  final Widget rightMenu;

  /// When the [JuntoFilterDrawer] is open, it's possible to set the offset of each of the four cardinal directions
  final IDOffset offset;

  /// edge radius when opening the scaffold - (defalut 0)
  final double borderRadius;

  /// Closes the open scaffold
  final bool onTapClose;

  /// activate or deactivate the swipe. NOTE: when deactivate, onTap Close is implicitly activated
  final bool swipe;

  /// duration animation controller
  final Duration duration;

  /// Static or Linear or Quadratic
  final InnerDrawerAnimation animationType;

  /// Optional callback that is called when a [JuntoFilterDrawer] is open or closed.
  final JuntoDrawerCallback innerDrawerCallback;

  /// when a pointer that is in contact with the screen and moves to the right or left
  final JuntoDragUpdateCallback onDragUpdate;

  @override
  JuntoFilterDrawerState createState() => JuntoFilterDrawerState();

  static JuntoFilterDrawerState of(BuildContext context,
      {bool nullOk = false}) {
    assert(nullOk != null);
    assert(context != null);
    final JuntoFilterDrawerState result =
        context.findAncestorStateOfType<JuntoFilterDrawerState>();
    if (nullOk || result != null) {
      return result;
    }
    return null;
  }
}

class JuntoFilterDrawerState extends State<JuntoFilterDrawer>
    with SingleTickerProviderStateMixin {
  final ColorTween _color =
      ColorTween(begin: Colors.transparent, end: Colors.black54);
  final ColorTween _scaffoldColor =
      ColorTween(begin: Colors.black54, end: Colors.transparent);

  double _initWidth = _kWidth;
  Orientation _orientation = Orientation.portrait;
  DrawerPosition _position;

  @override
  void initState() {
    _updateWidth();

    _position =
        widget.leftDrawer != null ? DrawerPosition.start : DrawerPosition.end;

    _controller = AnimationController(
        value: 1,
        duration: widget.duration ?? _kBaseSettleDuration,
        vsync: this)
      ..addListener(_animationChanged)
      ..addStatusListener(_animationStatusChanged);
    super.initState();
  }

  @override
  void dispose() {
    _historyEntry?.remove();
    _controller.dispose();
    super.dispose();
  }

  void _animationChanged() {
    setState(() {
      // The animation controller's state is our build state, and it changed already.
    });

    if (widget.onDragUpdate != null && _controller.value < 1) {
      widget.onDragUpdate(1 - _controller.value, _position);
    }
  }

  LocalHistoryEntry _historyEntry;
  final FocusScopeNode _focusScopeNode = FocusScopeNode();

  void _ensureHistoryEntry() {
    if (_historyEntry == null) {
      final ModalRoute<dynamic> route = ModalRoute.of(context);
      if (route != null) {
        _historyEntry = LocalHistoryEntry(onRemove: _handleHistoryEntryRemoved);
        route.addLocalHistoryEntry(_historyEntry);
        FocusScope.of(context).setFirstFocus(_focusScopeNode);
      }
    }
  }

  void _animationStatusChanged(AnimationStatus status) {
    final bool opened = _controller.value < 0.5;

    switch (status) {
      case AnimationStatus.reverse:
        break;
      case AnimationStatus.forward:
        break;
      case AnimationStatus.dismissed:
        if (_previouslyOpened != opened) {
          _previouslyOpened = opened;
          if (widget.innerDrawerCallback != null)
            widget.innerDrawerCallback(opened);
        }
        _ensureHistoryEntry();
        break;
      case AnimationStatus.completed:
        if (_previouslyOpened != opened) {
          _previouslyOpened = opened;
          if (widget.innerDrawerCallback != null)
            widget.innerDrawerCallback(opened);
        }
        _historyEntry?.remove();
        _historyEntry = null;
    }
  }

  void _handleHistoryEntryRemoved() {
    _historyEntry = null;
    _close();
  }

  AnimationController _controller;

  void _handleDragDown(DragDownDetails details) {
    _controller.stop();
  }

  final GlobalKey _drawerKey = GlobalKey();

  double get _width {
    return _initWidth;
  }

  /// get width of screen after initState
  void _updateWidth() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox box = _drawerKey.currentContext?.findRenderObject();
      if (box != null && box.size != null)
        setState(() {
          _initWidth = box.size.width;
        });
    });
  }

  bool _previouslyOpened = false;

  void _move(DragUpdateDetails details) {
    double delta = details.primaryDelta / _width;

    if (delta > 0 && _controller.value == 1 && widget.leftDrawer != null)
      _position = DrawerPosition.start;
    else if (delta < 0 && _controller.value == 1 && widget.rightMenu != null)
      _position = DrawerPosition.end;

    final double left =
        widget.offset != null ? widget.offset.left : widget.leftDrawer;
    final double right =
        widget.offset != null ? widget.offset.right : widget.rightMenu;

    double offset = _position == DrawerPosition.start ? left : right;

    double ee = 1;
    if (offset <= 0.2)
      ee = 1.7;
    else if (offset <= 0.4)
      ee = 1.2;
    else if (offset <= 0.6) {
      ee = 1.05;
    }

    offset = 1 - pow(offset / ee, 1 / 2);
    switch (_position) {
      case DrawerPosition.end:
        break;
      case DrawerPosition.start:
        delta = -delta;
        break;
    }

    switch (Directionality.of(context)) {
      case TextDirection.rtl:
        _controller.value -= delta + (delta * offset);
        break;
      case TextDirection.ltr:
        _controller.value += delta + (delta * offset);
        break;
    }

    final bool opened = _controller.value < 0.5;
    if (opened != _previouslyOpened && widget.innerDrawerCallback != null)
      widget.innerDrawerCallback(opened);
    _previouslyOpened = opened;
  }

  void _settle(DragEndDetails details) {
    if (_controller.isDismissed) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx / _width;

      switch (_position) {
        case DrawerPosition.end:
          break;
        case DrawerPosition.start:
          visualVelocity = -visualVelocity;
          break;
      }

      switch (Directionality.of(context)) {
        case TextDirection.rtl:
          _controller.fling(velocity: -visualVelocity);
          break;
        case TextDirection.ltr:
          _controller.fling(velocity: visualVelocity);
          break;
      }
    } else if (_controller.value < 0.5) {
      _open();
    } else {
      _close();
    }
  }

  void _open({DrawerPosition direction}) {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
    if (direction != null) _position = direction;
    _controller.fling(velocity: -1);
  }

  void _close({DrawerPosition direction}) {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
    if (direction != null) _position = direction;
    _controller.fling(velocity: 1);
  }

  /// Open or Close JuntoDrawer
  void toggle({DrawerPosition direction}) {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }
    if (direction != null) _position = direction;
    if (_previouslyOpened) {
      _close(direction: DrawerPosition.start);
      // _controller.fling(velocity: 1);
    } else {
      _open(direction: DrawerPosition.start);
      // _controller.fling(velocity: -1);
    }
  }

  void toggleRightMenu() {
    if (FocusScope.of(context).hasFocus) {
      FocusScope.of(context).unfocus();
    }

    if (_previouslyOpened) {
      // _controller.fling(velocity: 1);
      _close(direction: DrawerPosition.end);
    } else {
      // _controller.fling(velocity: -1);
      _open(direction: DrawerPosition.end);
    }
  }

  final GlobalKey _gestureDetectorKey = GlobalKey();

  /// Outer Alignment
  AlignmentDirectional get _drawerOuterAlignment {
    switch (_position) {
      case DrawerPosition.start:
        return AlignmentDirectional.centerEnd;
      case DrawerPosition.end:
        return AlignmentDirectional.centerStart;
    }
    return null;
  }

  /// Inner Alignment
  AlignmentDirectional get _drawerInnerAlignment {
    switch (_position) {
      case DrawerPosition.start:
        return AlignmentDirectional.centerStart;
      case DrawerPosition.end:
        return AlignmentDirectional.centerEnd;
    }
    return null;
  }

  InnerDrawerAnimation get _animationType {
    return widget.animationType;
  }

  double get _offset {
    final double left = widget.offset != null ? widget.offset.left : 0.9;

    return left;
  }

  /// return width with specific offset
  double get _widthWithOffset {
    return (_width / 2) - (_width / 2) * _offset;
  }

  /// return swipe
  bool get _swipe {
    return widget.swipe;
  }

  /// return widget with specific animation
  Widget _animatedChild() {
    final Widget child = _position == DrawerPosition.start
        ? widget.leftDrawer
        : widget.rightMenu;

    final Widget container = Container(
      width: _width - _widthWithOffset,
      height: MediaQuery.of(context).size.height,
      child: child,
    );

    switch (_animationType) {
      case InnerDrawerAnimation.linear:
        return Align(
          alignment: _drawerOuterAlignment,
          widthFactor: 1 - (_controller.value),
          child: container,
        );
      case InnerDrawerAnimation.quadratic:
        return Align(
          alignment: _drawerOuterAlignment,
          widthFactor: 1 - (_controller.value / 2),
          child: container,
        );
      default:
        return container;
    }
  }

  /// Disable the scaffolding tap when the drawer is open
  Widget _invisibleCover() {
    final Container container = Container(
      color: Colors.transparent,
    );
    if (_controller.status == AnimationStatus.dismissed)
      return BlockSemantics(
        child: GestureDetector(
          // On Android, the back button is used to dismiss a modal.
          excludeFromSemantics: defaultTargetPlatform == TargetPlatform.android,
          onTap: widget.onTapClose || !_swipe ? _close : null,
          child: Semantics(
            label: MaterialLocalizations.of(context)?.modalBarrierDismissLabel,
            child: container,
          ),
        ),
      );
    return null;
  }

  /// Scaffold
  Widget _scaffold() {
    assert(widget.borderRadius >= 0);

    Widget container = Container(
      key: _drawerKey,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          widget.borderRadius * (1 - _controller.value),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 5,
          )
        ],
      ),
      child: widget.borderRadius != 0
          ? ClipRRect(
              borderRadius: BorderRadius.circular(
                  (1 - _controller.value) * widget.borderRadius),
              child: widget.scaffold,
            )
          : widget.scaffold,
    );

    final Widget invC = _invisibleCover();
    if (invC != null)
      container = Stack(
        children: <Widget>[container, invC],
      );

    // Vertical translate
    if (widget.offset != null &&
        (widget.offset.top > 0 || widget.offset.bottom > 0)) {
      final double translateY = MediaQuery.of(context).size.height *
          (widget.offset.top > 0 ? -widget.offset.top : widget.offset.bottom);
      container = Transform.translate(
        offset: Offset(0, translateY * (1 - _controller.value)),
        child: container,
      );
    }

    return container;
  }

  @override
  Widget build(BuildContext context) {
    if (_initWidth == 400 ||
        MediaQuery.of(context).orientation != _orientation) {
      _updateWidth();
      _orientation = MediaQuery.of(context).orientation;
    }

    /// wFactor depends of offset and is used by the second Align that contains the Scaffold
    final double offset = 0.5 - _offset * 0.5;
    final double wFactor = (_controller.value * (1 - offset)) + offset;

    return Stack(
      alignment: _drawerInnerAlignment,
      children: <Widget>[
        GestureDetector(
          child: RepaintBoundary(
            child: _animatedChild(),
          ),
          onHorizontalDragDown: _swipe ? _handleDragDown : null,
          onHorizontalDragUpdate: _swipe ? _move : null,
          onHorizontalDragEnd: _swipe ? _settle : null,
          excludeFromSemantics: true,
        ),
        GestureDetector(
          key: _gestureDetectorKey,
          onTap: () {},
          onHorizontalDragDown: _swipe ? _handleDragDown : null,
          onHorizontalDragUpdate: _swipe ? _move : null,
          onHorizontalDragEnd: _swipe ? _settle : null,
          excludeFromSemantics: true,
          child: RepaintBoundary(
            child: Stack(
              children: <Widget>[
                DarkBackground(
                  controller: _controller,
                  animationType: _animationType,
                  color: _color,
                ),
                Align(
                  alignment: _drawerOuterAlignment,
                  child: Align(
                      alignment: _drawerInnerAlignment,
                      widthFactor: wFactor,
                      child: RepaintBoundary(
                        child: FocusScope(
                          node: _focusScopeNode,
                          child: Stack(
                            children: <Widget>[
                              _scaffold(),
                              _DarkScaffoldOverlay(
                                scaffoldColor: _scaffoldColor,
                                controller: _controller,
                              ),
                            ],
                          ),
                        ),
                      )),
                ),
              ].where((Widget a) => a != null).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class DarkBackground extends StatelessWidget {
  const DarkBackground({
    Key key,
    @required AnimationController controller,
    @required InnerDrawerAnimation animationType,
    @required ColorTween color,
  })  : _controller = controller,
        _animationType = animationType,
        _color = color,
        super(key: key);

  final AnimationController _controller;
  final InnerDrawerAnimation _animationType;
  final ColorTween _color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _controller.value == 0 ||
              _animationType == InnerDrawerAnimation.linear
          ? 0
          : null,
      color: _color.evaluate(_controller),
    );
  }
}

class _DarkScaffoldOverlay extends StatelessWidget {
  const _DarkScaffoldOverlay({
    Key key,
    @required ColorTween scaffoldColor,
    @required AnimationController controller,
  })  : _scaffoldColor = scaffoldColor,
        _controller = controller,
        super(key: key);

  final ColorTween _scaffoldColor;
  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: true,
      child: Container(
        color: _scaffoldColor.evaluate(_controller),
      ),
    );
  }
}

///An immutable set of offset in each of the four cardinal directions.
class IDOffset {
  const IDOffset.horizontal(
    double horizontal,
  )   : left = horizontal,
        top = 0.0,
        right = horizontal,
        bottom = 0.0;

  const IDOffset.only({
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
  })  : assert(top >= 0.0 &&
            top <= 1.0 &&
            left >= 0.0 &&
            left <= 1.0 &&
            right >= 0.0 &&
            right <= 1.0 &&
            bottom >= 0.0 &&
            bottom <= 1.0),
        assert(top >= 0.0 && bottom == 0.0 || top == 0.0 && bottom >= 0.0);

  /// The offset from the left.
  final double left;

  /// The offset from the top.
  final double top;

  /// The offset from the right.
  final double right;

  /// The offset from the bottom.
  final double bottom;
}
