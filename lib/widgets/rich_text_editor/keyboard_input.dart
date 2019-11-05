import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show TextInput, TextInputClient, TextInputConnection, TextInputConfiguration, RawFloatingCursorPoint;
import 'package:junto_beta_mobile/widgets/rich_text_editor/text_span_controller.dart';

mixin KeyboardInput<T extends StatefulWidget> on State<T> implements TextInputClient {
  TextSpanEditingController text = TextSpanEditingController();

  FocusScopeNode focusScopeNode;
  TextInputConnection _connection;

  bool get _hasInputConnection => _connection != null && _connection.attached;

  @override
  void initState() {
    super.initState();
    focusScopeNode = FocusScopeNode(debugLabel: 'Rich Text Editor Content Focus Scope');
    focusScopeNode.addListener(_onFocusChanged);
    text.addListener(_onTextChanged);
  }

  void _onFocusChanged() {
    if (focusScopeNode.hasFocus) {
      _openInputConnection();
    }
    onFocusChanged(focusScopeNode.hasFocus);
  }

  void _onTextChanged() {
    _connection?.setEditingState(text.value);
  }

  void onFocusChanged(bool hasFocus);

  @override
  void dispose() {
    text.removeListener(_onTextChanged);
    focusScopeNode.removeListener(_onFocusChanged);
    focusScopeNode.dispose();
    _closeInputConnectionIfNeeded();
    super.dispose();
  }

  void requestKeyboard() {
    if (focusScopeNode.hasFocus) {
      _openInputConnection();
    } else {
      focusScopeNode.requestFocus();
    }
  }

  void closeKeyboard() {
    _closeInputConnectionIfNeeded();
    focusScopeNode.unfocus();
  }

  void _openInputConnection() {
    if (!_hasInputConnection) {
      _connection = TextInput.attach(
        this,
        const TextInputConfiguration(
          inputType: TextInputType.multiline,
          inputAction: TextInputAction.newline,
          keyboardAppearance: Brightness.light,
          textCapitalization: TextCapitalization.sentences,
        ),
      );
      _connection.setEditingState(text.value);
    }
    _connection.show();
  }

  void _closeInputConnectionIfNeeded() {
    if (_hasInputConnection) {
      _connection.close();
      _connection = null;
    }
  }

  @override
  TextEditingValue get currentTextEditingValue => text.value;

  @override
  void updateEditingValue(TextEditingValue value) {
    print('updateEditingValue $value');
    text.value = value;
  }

  @override
  void updateFloatingCursor(RawFloatingCursorPoint point) {
    print('updateFloatingCursor $point');
    // TODO: implement updateFloatingCursor
  }

  @override
  void performAction(TextInputAction action) {
    if (action == TextInputAction.next) {
      // TODO: goto next item
    } else if (action == TextInputAction.done) {
      // TODO: close keyboard?
    }
  }

  @override
  void connectionClosed() {
    print('connectionClosed');
    // TODO: implement connectionClosed
  }
}
