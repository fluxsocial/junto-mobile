import 'package:flutter/material.dart';
import '../../models/expression.dart';
import './bullet_preview.dart';
import './event_preview.dart';
import './longform_preview.dart';
import './music_preview.dart';
import './photo_preview.dart';
import './preview_bottom.dart';
import './preview_profile.dart';
import './shortform_preview.dart';
import './video_preview.dart';

/// Renders a concise overview of one given [Expression].
class ExpressionPreview extends StatelessWidget {
  final Expression _expression;
  final String urk = 'sunyatax';

  ExpressionPreview(this._expression);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // expression preview profile
          PreviewProfile(urk),

          // expression preview body
          _returnExpression(),

          // expression preview channels, resonation, and comments
          PreviewBottom()
        ],
      ),
    );
  }

// TODO cite what this method does
  Widget _returnExpression() {
    if (_expression.expressionType == 'longform') {
      return LongformPreview(_expression.title, _expression.body);
    } else if (_expression.expressionType == 'shortform') {
      return ShortformPreview();
    } else if (_expression.expressionType == 'bullet') {
      return BulletPreview();
    } else if (_expression.expressionType == 'photo') {
      return PhotoPreview(_expression.image);
    } else if (_expression.expressionType == 'event') {
      return EventPreview();
    } else if (_expression.expressionType == 'music') {
      return MusicPreview();
    } else if (_expression.expressionType == 'video') {
      return VideoPreview();
    } else {
      return Container(
        width: 0,
        height: 0,
      );
    }
  }
}
