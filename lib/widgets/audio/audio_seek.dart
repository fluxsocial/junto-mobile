import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';
import 'package:junto_beta_mobile/utils/extensions/duration_ext.dart';

class AudioSeek extends StatelessWidget {
  const AudioSeek({
    Key key,
    this.hasBackground,
  }) : super(key: key);

  final bool hasBackground;

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(
      builder: (context, audio, child) {
        return Expanded(
          child: Container(
            height: 36,
            child: SliderTheme(
              data: SliderThemeData(
                inactiveTrackColor: hasBackground
                    ? Colors.white
                    : Theme.of(context).dividerColor,
                activeTrackColor: hasBackground
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                thumbColor: hasBackground
                    ? Colors.white
                    : Theme.of(context).primaryColor,
                trackHeight: 5,
              ),
              child: Slider(
                value: getCurrentPosition(audio),
                max: getMaxDuration(audio),
                min: 0,
                onChanged: (val) {
                  audio.seek(val.roundToDouble());
                },
              ),
            ),
          ),
        );
      },
    );
  }

  double getCurrentPosition(AudioService audio) {
    Duration max;
    if (audio.recordingAvailable) {
      max = audio.recordingDuration;
    } else {
      max = audio.maxDuration;
    }

    final duration = audio.currentPosition;
    if (duration != null) {
      return duration.secondCeilRounder(max).inSeconds.toDouble();
    }
    return 0;
  }

  num getMaxDuration(AudioService audio) {
    if (audio.playBackAvailable) {
      return audio.recordingDuration.secondFloorRounder().inSeconds.toDouble();
    }

    return audio.maxDuration.secondFloorRounder().inSeconds.toDouble();
  }
}
