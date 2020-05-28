import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';

class AudioPlayButton extends StatelessWidget {
  const AudioPlayButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audio, child) {
        return Semantics(
          button: true,
          label: _getLabel(audio),
          child: GestureDetector(
            onTap: () async {
              if (audio.isPlaying) {
                await audio.pausePlayback();
              } else if (audio.playBackAvailable && !audio.isPlaying) {
                await audio.playRecording();
              } else if (audio.playBackAvailable && audio.isPlaying) {
                await audio.pausePlayback();
              } else {
                await audio.pausePlayback();
              }
            },
            child: child,
          ),
        );
      },
      child: AudioPlayIcon(),
    );
  }

  String _getLabel(AudioService audio) {
    if (audio.isPlaying) {
      return 'Pause playing';
    } else if (audio.playBackAvailable && !audio.isPlaying) {
      return 'Start playing';
    } else if (audio.playBackAvailable && audio.isPlaying) {
      return 'Pause playing';
    } else {
      return 'Pause recording';
    }
  }
}

class AudioPlayIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audio, child) {
        if (audio.playBackAvailable && !audio.isPlaying) {
          return Icon(
            Icons.play_arrow,
            size: 33,
            color: Colors.white,
          );
        } else if (audio.playBackAvailable && audio.isPlaying) {
          return Icon(
            Icons.pause,
            size: 33,
            color: Colors.white,
          );
        } else {
          return Icon(
            Icons.play_arrow,
            size: 33,
            color: Colors.white,
          );
        }
      },
    );
  }
}
