
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

class ExpressionPreview extends StatelessWidget {

  final String urk = 'sunyatax'; 
  var longform = true; 
  var shortform = false;
  var bullet = false; 
  var photo = false;  
  var event = false; 
  var music = false;
  var video = false;

  Widget _returnExpression() {
    if(longform) {
      return LongformPreview();
    } else if (shortform) {
      return ShortformPreview();
    } else if (bullet) {
      return BulletPreview();
    } else if (photo) {
      return PhotoPreview();
    } else if (event) {
      return EventPreview();
    } else if (music) {
      return MusicPreview();
    } else if (video) {
      return VideoPreview();
    } else {
      return Container(width: 0 , height: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.all(15.0),
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
