import 'package:flutter/material.dart';

class RichTextControl {
  const RichTextControl._(this.name, this.icon);

  final String name;
  final IconData icon;

  static const RichTextControl TitleToggle = RichTextControl._('TitleToggle', Icons.text_fields);
  static const RichTextControl Quote = RichTextControl._('Quote', Icons.format_quote);
  static const RichTextControl BulletList = RichTextControl._('BulletList', Icons.format_list_bulleted);
  static const RichTextControl LineBreak = RichTextControl._('LineBreak', Icons.view_headline);
  static const RichTextControl Bold = RichTextControl._('Bold', Icons.format_bold);
  static const RichTextControl Italic = RichTextControl._('Italic', Icons.format_italic);
  static const RichTextControl Link = RichTextControl._('Link', Icons.insert_link);
  static const RichTextControl InsertPhoto = RichTextControl._('InsertPhoto', Icons.insert_photo);

  static const List<RichTextControl> values = <RichTextControl>[
    TitleToggle,
    Quote,
    BulletList,
    LineBreak,
    Bold,
    Italic,
    Link,
    InsertPhoto
  ];

  @override
  String toString() => '$runtimeType{$name}';
}

class RichTextControlsMode {
  const RichTextControlsMode._(this._controls);

  final Set<RichTextControl> _controls;

  static const RichTextControlsMode InsertMode = RichTextControlsMode._(<RichTextControl>{
    RichTextControl.TitleToggle,
    RichTextControl.Quote,
    RichTextControl.BulletList,
    RichTextControl.LineBreak,
    RichTextControl.Bold,
    RichTextControl.Italic,
    RichTextControl.Link,
    RichTextControl.InsertPhoto,
  });

  static const RichTextControlsMode SelectionMode = RichTextControlsMode._(<RichTextControl>{
    RichTextControl.Bold,
    RichTextControl.Italic,
    RichTextControl.Link,
  });

  bool contains(RichTextControl control) => _controls.contains(control);

  int get controlCount => _controls.length;
}

class RichTextControls extends StatefulWidget {
  const RichTextControls({
    Key key,
    this.mode = RichTextControlsMode.InsertMode,
    this.onPressed,
  }) : super(key: key);

  final RichTextControlsMode mode;
  final ValueChanged<RichTextControl> onPressed;

  @override
  _RichTextControlsState createState() => _RichTextControlsState();
}

class _RichTextControlsState extends State<RichTextControls> with TickerProviderStateMixin {
  Map<RichTextControl, GlobalKey> _keys;

  @override
  void initState() {
    super.initState();
    _keys = Map<RichTextControl, GlobalKey>.fromIterables(
      RichTextControl.values,
      RichTextControl.values.map((RichTextControl control) => GlobalKey(debugLabel: 'button-${control.icon}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return Material(
      elevation: 4.0,
      shape: Border(
        top: BorderSide(width: mediaQuery.devicePixelRatio, color: const Color(0xFFEEEEEE)),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double buttonWidth = constraints.maxWidth / widget.mode.controlCount;
          return SizedBox(
            height: kToolbarHeight,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: RichTextControl.values.map<Widget>((RichTextControl control) {
                final bool hasButton = widget.mode.contains(control);
                return ClipRect(
                  child: AnimatedSize(
                    key: _keys[control],
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutCubic,
                    vsync: this,
                    child: SizedOverflowBox(
                      size: Size(hasButton ? buttonWidth : 0.0, double.infinity),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubic,
                        opacity: hasButton ? 1.0 : 0.0,
                        child: IconButton(
                          icon: Icon(control.icon),
                          onPressed: () => widget.onPressed?.call(control),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
