import 'package:flutter/material.dart';

class RichTextEditorToolbar extends StatelessWidget
    implements PreferredSizeWidget {
  const RichTextEditorToolbar({
    Key key,
    this.toggleAttributions,
    this.addList,
    this.addHorizontalRule,
    this.addImage,
    this.toggleBlocktype,
  }) : super(key: key);

  final Function(String) toggleAttributions;
  final Function(String) toggleBlocktype;
  final Function({bool ordered}) addList;
  final Function addHorizontalRule;
  final Function addImage;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: [
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.format_bold),
            onPressed: () => toggleAttributions('bold'),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.format_italic),
            onPressed: () => toggleAttributions('italics'),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.format_strikethrough),
            onPressed: () => toggleAttributions('strikethrough'),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.format_quote),
            onPressed: () => toggleBlocktype('blockquote'),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.format_underline),
            onPressed: () => toggleAttributions('underline'),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.format_list_bulleted),
            onPressed: () => addList(ordered: false),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.format_list_numbered),
            onPressed: () => addList(ordered: true),
          ),
        ),
        Transform.scale(
          scale: 0.8,
          child: IconButton(
            padding: EdgeInsets.all(2.0),
            icon: Icon(Icons.horizontal_rule),
            onPressed: addHorizontalRule,
          ),
        ),
        TextButton(
          onPressed: () => toggleBlocktype('header1'),
          child: Text(
            'H1',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () => toggleBlocktype('header2'),
          child: Text(
            'H2',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () => toggleBlocktype('header3'),
          child: Text(
            'H3',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60);
}
