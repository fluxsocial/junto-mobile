import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/widgets/audio/audio_position.dart';

class AudioTimer extends StatelessWidget {
  const AudioTimer({this.audio});
  final audio;
  @override
  Widget build(BuildContext context) {
    return Text(
      AudioPosition().getCurrentPosition(audio),
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: 2.4,
        color: Theme.of(context).primaryColorLight,
      ),
    );
  }
}
