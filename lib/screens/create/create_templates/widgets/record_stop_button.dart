import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';

class RecordStopButton extends StatelessWidget {
  const RecordStopButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audio, child) {
        if (audio.isRecording) {
          return IconButton(
            icon: Icon(Icons.stop),
            onPressed: () async {
              await audio.stopRecording();
              
            },
          );
        } else {
          return IconButton(
            icon: Icon(Icons.fiber_manual_record),
            onPressed: () async {
              await audio.startRecording();
            },
          );
        }
      },
    );
  }
}
