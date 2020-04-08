import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'audio_service.dart';
import 'widgets/audio_position.dart';
import 'widgets/audio_seek.dart';
import 'widgets/play_stop_button.dart';
import 'widgets/record_stop_button.dart';
import 'widgets/remove_audio_button.dart';

class CreateAudio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AudioService>(
      create: (context) => AudioService(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Record audio'),
        ),
        body: CreateAudioBody(),
      ),
    );
  }
}

class CreateAudioBody extends StatelessWidget {
  const CreateAudioBody({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Record audio'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PlayStopButton(),
            RecordStopButton(),
            RemoveAudioButton(),
          ],
        ),
        AudioPosition(),
        AudioSeek(),
      ],
    );
  }
}
