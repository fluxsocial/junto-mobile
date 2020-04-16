import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';

import 'audio_button_background.dart';

class AudioButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audio, child) {
        if (audio.isRecording) {
          return Icon(
            Icons.stop,
            size: 33,
            color: Colors.white,
          );
        } else if (audio.playBackAvailable && !audio.isPlaying) {
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
            Icons.mic,
            size: 33,
            color: Colors.white,
          );
        }
      },
    );
  }
}

class AudioButtonStack extends StatelessWidget {
  const AudioButtonStack({
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
              if (audio.isRecording) {
                await audio.stopRecording();
              } else if (audio.isPlaying) {
                await audio.pausePlayback();
              } else if (audio.playBackAvailable && !audio.isPlaying) {
                await audio.playRecording();
              } else if (audio.playBackAvailable && audio.isPlaying) {
                await audio.pausePlayback();
              } else {
                await audio.startRecording();
              }
            },
            child: child,
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          AudioButtonBackground(),
          Container(
            height: 80,
            width: 80,
            alignment: Alignment.center,
            child: AudioButton(),
          ),
        ],
      ),
    );
  }

  String _getLabel(AudioService audio) {
    if (audio.isRecording) {
      return 'Stop recording';
    } else if (audio.isPlaying) {
      return 'Pause playing';
    } else if (audio.playBackAvailable && !audio.isPlaying) {
      return 'Start playing';
    } else if (audio.playBackAvailable && audio.isPlaying) {
      return 'Pause playing';
    } else {
      return 'Start recording';
    }
  }
}
