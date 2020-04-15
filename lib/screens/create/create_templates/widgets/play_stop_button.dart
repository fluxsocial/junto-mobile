import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';

class PlayStopButton extends StatelessWidget {
  const PlayStopButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audio, child) {
        if (audio.isPlaying) {
          return IconButton(
            icon: Icon(Icons.stop),
            onPressed: audio.isPlaying
                ? () async {
                    await audio.stopPlayback();
                  }
                : null,
          );
        }
        return IconButton(
          icon: Icon(Icons.play_arrow),
          onPressed: audio.playBackAvailable
              ? () async {
                  await audio.playRecording();
                }
              : null,
        );
      },
    );
  }
}