import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';

class RemoveAudioButton extends StatelessWidget {
  const RemoveAudioButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audio, child) {
        return IconButton(
          icon: Icon(Icons.delete),
          onPressed: audio.playBackAvailable && !audio.isPlaying
              ? () async {
                  await audio.resetRecording();
                }
              : null,
        );
      },
    );
  }
}
