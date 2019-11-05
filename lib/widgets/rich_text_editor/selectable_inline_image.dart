import 'package:flutter/material.dart';

class SelectableInlineImage extends StatefulWidget {
  const SelectableInlineImage({
    Key key,
    @required this.image,
    this.onSelected,
  }) : super(key: key);

  final ImageProvider image;
  final ValueChanged<bool> onSelected;

  @override
  _SelectableInlineImageState createState() => _SelectableInlineImageState();
}

class _SelectableInlineImageState extends State<SelectableInlineImage> {
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (bool hasFocus) {
        setState(() => _hasFocus = hasFocus);
        widget.onSelected?.call(hasFocus);
      },
      child: Builder(
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () => Focus.of(context).requestFocus(),
            child: AnimatedContainer(
              duration: kThemeChangeDuration,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _hasFocus ? Colors.blue : Colors.transparent,
                  width: 2.0,
                ),
              ),
              foregroundDecoration: BoxDecoration(
                color: _hasFocus ? Colors.blue.withOpacity(0.33) : Colors.transparent,
              ),
              child: Image(
                image: widget.image,
                width: double.infinity,
                height: 128.0,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
