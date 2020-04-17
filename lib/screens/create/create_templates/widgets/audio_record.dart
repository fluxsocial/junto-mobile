import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../audio_service.dart';
import 'audio_button.dart';
import 'audio_button_decoration.dart';
import 'audio_seek.dart';
import 'audio_timer.dart';

class AudioRecord extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(builder: (context, audio, child) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Transform.translate(
              offset: Offset(0.0, -50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      AudioButtonDecoration(
                        child: AudioButtonStack(),
                      ),
                      const SizedBox(height: 15),
                      audio.playBackAvailable
                          ? AudioSeek()
                          : AudioTimer(audio: audio)
                    ],
                  ),
                ],
              ),
            ),
          ]);
    });
  }
}
