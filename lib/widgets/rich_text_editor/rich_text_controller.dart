import 'package:flutter/material.dart';

import 'nodes/types.dart';
import 'rich_text_controls.dart';
import 'rich_text_editor.dart';

class RichTextController extends ChangeNotifier {
  final List<RichTextNode> _nodes = <RichTextNode>[];
  List<RichTextNode> get nodes => _nodes;

  RichTextControlsMode _controlsMode = RichTextControlsMode.InsertMode;
  RichTextControlsMode get controlsMode => _controlsMode;

  RichTextNode get currentNode {
    return _nodes.firstWhere(
      (node) => node.focus.hasFocus,
      orElse: () => null,
    );
  }

  void _deleteNode(RichTextNode node) {
    if (_nodes.contains(node)) {
      // In order to avoid keybord hide-and-show we switch focus to previous node
      final previousNode = nodes[nodes.indexOf(node) - 1];
      previousNode.focus.requestFocus();
      _nodes.remove(node);
    }
    notifyListeners();
  }

  void addNode({bool inPlaceInsert = false}) {
    print('addNode(inPlace: $inPlaceInsert)');
    final RichTextNode focusedNode = currentNode;
    RichTextNode node;
    if (inPlaceInsert && !(focusedNode?.isEmpty ?? true)) {
      node = RichTextNode(RichTextNodeType.Text);
      _nodes.insert(_nodes.indexOf(focusedNode) + 1, node);
    } else {
      node = _nodes.isNotEmpty ? _nodes[_nodes.length - 1] : null;
      if (node == null || node.text.value.text.isNotEmpty) {
        node = RichTextNode(RichTextNodeType.Text);
        _nodes.add(node);
      } else {
        node.focus.requestFocus();
        return;
      }
    }
    node.text.addListener(() => onTextChanged(node));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      node.focus.requestFocus();
    });
    notifyListeners();
  }

  void onControlPressed(RichTextControl control) {
    final RichTextNode node = currentNode;
    print('control $control');
    switch (control) {
      case RichTextControl.TitleToggle:
        switch (node.type) {
          case RichTextNodeType.Text:
            node.type = RichTextNodeType.Title;
            break;
          case RichTextNodeType.Title:
            node.type = RichTextNodeType.Subtitle;
            break;
          case RichTextNodeType.Subtitle:
          default:
            node.type = RichTextNodeType.Text;
            break;
        }
        break;
      case RichTextControl.Quote:
        switch (node.type) {
          case RichTextNodeType.Quote:
            node.type = RichTextNodeType.Text;
            break;
          case RichTextNodeType.Text:
          default:
            node.type = RichTextNodeType.Quote;
            break;
        }
        break;
      case RichTextControl.BulletList:
        switch (node.type) {
          case RichTextNodeType.OrderedBulletList:
            node.type = RichTextNodeType.UnorderedBulletList;
            break;
          case RichTextNodeType.UnorderedBulletList:
          default:
            node.type = RichTextNodeType.OrderedBulletList;
            break;
        }
        break;
      case RichTextControl.LineBreak:
        node.type = RichTextNodeType.LineBreak;
        break;
      case RichTextControl.Bold:
        break;
      case RichTextControl.Italic:
        break;
      case RichTextControl.Link:
        //showDialog
        // InsertLinkDialog.show(context).then((String value) {
        //   if (value != null) {
        //     node.type = RichTextNodeType.LinkUrl;
        //   }
        // });
        break;
      case RichTextControl.InsertPhoto:
        switch (node.type) {
          case RichTextNodeType.PhotoSmall:
            node.type = RichTextNodeType.PhotoMedium;
            break;
          case RichTextNodeType.PhotoMedium:
            node.type = RichTextNodeType.PhotoLarge;
            break;
          case RichTextNodeType.PhotoLarge:
          default:
            node.type = RichTextNodeType.PhotoSmall;
            break;
        }
        break;
    }
    notifyListeners();
    print('control $control > ${node.type}');
  }

  @override
  dispose() {
    for (final RichTextNode node in _nodes) {
      node.dispose();
    }
    super.dispose();
  }

  void onTextChanged(RichTextNode node) {
    if (currentNode == node) {
      _controlsMode = (!node.selection.isCollapsed)
          ? RichTextControlsMode.SelectionMode
          : RichTextControlsMode.InsertMode;
      notifyListeners();
    }

    if (node.text.value.text.isEmpty) {
      if (nodes.length > 1) {
        _deleteNode(node);
      }
    }
  }
}
