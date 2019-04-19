
import 'package:flutter/material.dart';

import './preview_profile.dart';
import './preview_bottom.dart';

// expression types
import './longform_preview.dart';
import './shortform_preview.dart';
import './bullet_preview.dart';
import './photo_preview.dart';
import './event_preview.dart';
import './music_preview.dart';
import './video_preview.dart';

/// Renders a concise overview of one given [Expression]. 
class ExpressionPreview extends StatelessWidget {

  // final List expressionsCollective;  
  // final index;

  // ExpressionPreview(this.expressionsCollective, this.index);

  final String _expressionType;
  final String _expressionTitle;
  final String _expressionBody;
  final String _expressionPhoto;

  ExpressionPreview(this._expressionType, this._expressionTitle, this._expressionBody, this._expressionPhoto);

  final String urk = 'sunyatax'; 

  Widget _returnExpression() { 

    if (_expressionType == 'longform') {
      return LongformPreview(_expressionTitle, _expressionBody);
    } else if(_expressionType == 'shortform') {
      return ShortformPreview();
    } else if(_expressionType == 'bullet') {
      return BulletPreview();
    } else if(_expressionType == 'photo') {
      return PhotoPreview(_expressionPhoto);
    } else if(_expressionType == 'event') {
      return EventPreview();
    } else if(_expressionType == 'music') {
      return MusicPreview();
    } else if(_expressionType == 'video') {
      return VideoPreview();
    } else {
      return Container(width: 0, height: 0,);
    }

    // if (expressionsCollective[index]['expressionType'] == 'longform') {
    //   return LongformPreview(expressionsCollective[index]['title'], expressionsCollective[index]['body']);
    // } else if(expressionsCollective[index]['expressionType'] == 'shortform') {
    //   return ShortformPreview();
    // } else if(expressionsCollective[index]['expressionType'] == 'bullet') {
    //   return BulletPreview();
    // } else if(expressionsCollective[index]['expressionType'] == 'photo') {
    //   return PhotoPreview(expressionsCollective[index]['image']);
    // } else if(expressionsCollective[index]['expressionType'] == 'event') {
    //   return EventPreview();
    // } else if(expressionsCollective[index]['expressionType'] == 'music') {
    //   return MusicPreview();
    // } else if(expressionsCollective[index]['expressionType'] == 'video') {
    //   return VideoPreview();
    // } else {
    //   return Container(width: 0, height: 0,);
    // }    
  }
 
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
}