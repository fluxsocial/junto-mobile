import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/audio/audio_position.dart';

class AudioTimer extends StatelessWidget {
  const AudioTimer({this.audio});
  final audio;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      child: Text(
        AudioPosition().getCurrentPosition(audio),
        style: TextStyle(
          fontSize: 20,
          letterSpacing: 2,
          color: Theme.of(context).primaryColorLight,
        ),
      ),
    );
  }
}
