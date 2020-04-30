import 'package:flutter/material.dart';
import 'package:junto_beta_mobile/screens/create/create_templates/audio_service.dart';
import 'package:provider/provider.dart';

class AudioBottomTools extends StatelessWidget {
  const AudioBottomTools({this.onPickPressed, this.resetAudioPhotoBackground});

  final Function resetAudioPhotoBackground;
  final Function onPickPressed;
  @override
  Widget build(BuildContext context) {
    return Consumer<AudioService>(builder: (context, audio, child) {
      return SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: .75,
                  ),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        await audio.resetRecording();
                        resetAudioPhotoBackground();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          color: Theme.of(context).primaryColorLight,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        // show gradient selector
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.invert_colors,
                          color: Theme.of(context).primaryColorLight,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        onPickPressed();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.camera_alt,
                          color: Theme.of(context).primaryColorLight,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
