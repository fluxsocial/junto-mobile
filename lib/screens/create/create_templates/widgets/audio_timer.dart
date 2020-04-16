import 'package:flutter/material.dart';
import 'audio_position.dart';

class AudioTimer extends StatelessWidget {
  const AudioTimer({this.audio});
  final audio;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        AudioPosition().getCurrentPosition(audio),
        style: TextStyle(
          fontSize: 28,
          letterSpacing: 1.7,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }
}
