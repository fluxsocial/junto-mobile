import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';

class AudioSeek extends StatelessWidget {
  const AudioSeek({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Consumer<AudioService>(
        builder: (context, audio, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SliderTheme(
              data: SliderThemeData(
                thumbColor: Colors.blue,
              ),
              child: Slider(
                value: getCurrentPosition(audio),
                max: getMaxDuration(audio),
                min: 0,
                onChanged: (val) {
                  audio.seek(val);
                },
              ),
            ),
          );
        },
      );
    });
  }

  double getCurrentPosition(AudioService audio) {
    final duration = audio.currentPosition;
    if (duration != null) return duration.inMilliseconds / 1000;
    return 0;
  }

  num getMaxDuration(AudioService audio) {
    if (audio.playBackAvailable) {
      return audio.recordingDuration.inMilliseconds / 1000;
    }

    return audio.maxDuration.inMilliseconds / 1000;
  }
}
