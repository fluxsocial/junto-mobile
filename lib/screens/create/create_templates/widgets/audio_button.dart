import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';

class AudioButton extends StatelessWidget {
  const AudioButton({
    this.setBottomNav,
    Key key,
  }) : super(key: key);

  final Function setBottomNav;

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audio, child) {
        if (audio.isRecording) {
          return IconButton(
            icon: Icon(
              Icons.stop,
              size: 33,
              color: Colors.white,
            ),
            onPressed: () async {
              await audio.stopRecording();
              setBottomNav(false);
            },
          );
        } else if (audio.playBackAvailable && !audio.isPlaying) {
          return IconButton(
            icon: Icon(
              Icons.play_arrow,
              size: 33,
              color: Colors.white,
            ),
            onPressed: () async {
              await audio.playRecording();
            },
          );
        } else if (audio.playBackAvailable && audio.isPlaying) {
          return IconButton(
            icon: Icon(
              Icons.pause,
              size: 33,
              color: Colors.white,
            ),
            onPressed: () async {
              await audio.stopPlayback();
            },
          );
        } else {
          return IconButton(
            icon: Icon(
              Icons.mic,
              size: 33,
              color: Colors.white,
            ),
            onPressed: () async {
              await audio.startRecording();
            },
          );
        }
      },
    );
  }
}
