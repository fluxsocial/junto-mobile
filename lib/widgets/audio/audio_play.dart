import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/app/custom_icons.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';

class AudioPlayButton extends StatelessWidget {
  const AudioPlayButton({
    Key key,
    this.hasBackground,
  }) : super(key: key);

  final bool hasBackground;

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
      child: AudioPlayIcon(
        hasBackground: hasBackground,
      ),
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
      return 'Start playing';
    }
  }
}

class AudioPlayIcon extends StatelessWidget {
  AudioPlayIcon({this.hasBackground});
  final bool hasBackground;
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audio, child) {
        if (audio.playBackAvailable && !audio.isPlaying) {
          return Container(
            color: Colors.transparent,
            child: Icon(
              CustomIcons.play,
              size: 33,
              color:
                  hasBackground ? Colors.white : Theme.of(context).primaryColor,
            ),
          );
        } else if (audio.playBackAvailable && audio.isPlaying) {
          return Container(
            color: Colors.transparent,
            child: Icon(
              CustomIcons.pause,
              size: 33,
              color:
                  hasBackground ? Colors.white : Theme.of(context).primaryColor,
            ),
          );
        } else {
          return Container(
            color: Colors.transparent,
            child: Icon(
              CustomIcons.play,
              size: 33,
              color:
                  hasBackground ? Colors.white : Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }
}
