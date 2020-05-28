import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';

class AudioButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audio, child) {
        if (audio.isRecording) {
          return Icon(
            Icons.stop,
            size: 28,
            color: Theme.of(context).primaryColor,
          );
        } else {
          return Icon(
            Icons.mic,
            size: 28,
            color: Theme.of(context).primaryColor,
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
          Container(
            height: 60,
            width: 60,
            alignment: Alignment.center,
            color: Colors.transparent,
            child: AudioButton(),
          ),
        ],
      ),
    );
  }

  String _getLabel(AudioService audio) {
    if (audio.isRecording) {
      return 'Stop recording';
    } else {
      return 'Start recording';
    }
  }
}
