import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';

import 'audio_play.dart';
import 'audio_position.dart';
import 'audio_seek.dart';

class AudioPlaybackRow extends StatelessWidget {
  const AudioPlaybackRow({
    Key key,
    this.hasBackground,
  }) : super(key: key);

  final bool hasBackground;

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audio, child) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Row(
            children: <Widget>[
              AudioPlayButton(
                hasBackground: hasBackground,
              ),
              AudioSeek(hasBackground: hasBackground),
              AudioPosition(hasBackground: hasBackground),
            ],
          ),
        );
      },
    );
  }
}
