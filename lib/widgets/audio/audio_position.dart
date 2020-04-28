import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';

class AudioPosition extends StatelessWidget {
  const AudioPosition({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audio, child) {
        return Text(
          '${getCurrentPosition(audio)} / ${getMaxDuration(audio)}',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        );
      },
    );
  }

  String getCurrentPosition(AudioService audio) {
    if (audio.currentPosition != null) {
      return formatDuration(audio.currentPosition);
    }
    return '0:00';
  }

  String getMaxDuration(AudioService audio) {
    if (audio.recordingAvailable) {
      return formatDuration(audio.recordingDuration);
    } else {
      return formatDuration(audio.maxDuration);
    }
  }

  String formatDuration(Duration duration) {
    final min = duration.inMinutes;
    final sec = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$min:$sec';
  }
}
